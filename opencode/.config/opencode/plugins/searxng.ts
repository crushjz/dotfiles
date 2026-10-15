/**
 * SearxNG websearch provider for opencode.
 *
 * SearxNG is self-hosted, so it cannot be named in `websearch.provider` in
 * opencode.json(c) — that setting only accepts a built-in provider, `random`, or
 * false. Registering it here instead makes it a real provider: it shows up in
 * provider selection and searches go through the normal `websearch` permission
 * action like any other.
 *
 * ## Configuration
 *
 * The instance base URL is read from the `OPENCODE_SEARXNG_URL` environment
 * variable and falls back to `https://localhost:8080` when it is unset:
 *
 * ```sh
 * OPENCODE_SEARXNG_URL=https://searxng.example.com
 * ```
 *
 * The instance must serve the JSON output format (`search.formats` includes
 * `json` in SearxNG's `settings.yml`). Without it, `/search` answers with an
 * HTML page instead of JSON and every query fails.
 *
 * ## Notes
 *
 * Results are capped at `MAX_RESULTS` and requests are bounded by `TIMEOUT_MS`.
 * Only `url`, `title`, `content`, and `time.published` are forwarded: the
 * `WebSearch.Result` schema rejects unknown keys, so the rest of SearxNG's
 * metadata is dropped.
 */

import { Plugin } from "@opencode/plugin";

const BASE = process.env.OPENCODE_SEARXNG_URL?.trim() || "https://localhost:8080";
const PROVIDER_ID = "searxng";

// A query commonly returns more hits than are worth reading back into context.
const MAX_RESULTS = 10;

// SearxNG aggregates a dozen upstream engines, so a query is not guaranteed to
// fail fast. Bound it, but let the caller's signal win so stopping the session
// still stops the request.
const TIMEOUT_MS = 15_000;

interface SearxngResult {
  url?: unknown;
  title?: unknown;
  content?: unknown;
  publishedDate?: unknown;
}

/**
 * Convert an ISO timestamp to epoch milliseconds.
 *
 * SearxNG reports `publishedDate` as an ISO string or null, but some engines
 * only give a coarse date. A date that `Date` cannot parse yields NaN, which
 * would fail schema validation on a numeric field, so anything unparseable is
 * dropped and the result keeps a bare `time` instead.
 */
function publishedMs(value: unknown): number | undefined {
  if (typeof value !== "string") return undefined;
  const parsed = Date.parse(value);
  return Number.isFinite(parsed) ? parsed : undefined;
}

async function search(query: string, signal: AbortSignal) {
  const url = `${BASE}/search?q=${encodeURIComponent(query)}` + `&format=json&language=en`;

  const response = await fetch(url, {
    signal: AbortSignal.any([signal, AbortSignal.timeout(TIMEOUT_MS)]),
  });

  // SearxNG answers a malformed or rate-limited request with a non-2xx
  // status, and an HTML error page instead of JSON. Throwing surfaces the
  // failure in the transcript where the model can report it; returning []
  // would read as a search that legitimately found nothing.
  if (!response.ok) {
    throw new Error(`SearxNG search failed: HTTP ${response.status}`);
  }

  const body = (await response.json()) as { results?: SearxngResult[] };
  const results = Array.isArray(body.results) ? body.results : [];

  return results
    .filter((result): result is SearxngResult & { url: string } => typeof result.url === "string")
    .slice(0, MAX_RESULTS)
    .map((result) => {
      // `url` and `time` are required by the WebSearch.Result schema, and
      // it rejects unknown keys — so engine, score, and infoboxes are all
      // dropped rather than passed through.
      const published = publishedMs(result.publishedDate);
      return {
        url: result.url,
        title: typeof result.title === "string" ? result.title : undefined,
        content: typeof result.content === "string" ? result.content : undefined,
        time: published === undefined ? {} : { published },
      };
    });
}

export default Plugin.define({
  id: "searxng-websearch",
  async setup(ctx) {
    await ctx.websearch.transform((editor) => {
      editor.add({
        id: PROVIDER_ID,
        name: "SearxNG",
        // `execute` only receives the query, not the provider ID, so this
        // cannot branch on which provider the session selected.
        execute: ({ query }, { signal }) => search(query, signal),
      });

      editor.default.set(PROVIDER_ID);
    });
  },
});
