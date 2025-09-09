local blink = require 'blink.cmp'

blink.setup {
  -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
  -- 'super-tab' for mappings similar to vscode (tab to accept)
  -- 'enter' for enter to accept
  -- 'none' for no mappings
  --
  -- All presets have the following mappings:
  -- C-space: Open menu or open docs if already open
  -- C-n/C-p or Up/Down: Select next/previous item
  -- C-e: Hide menu
  -- C-k: Toggle signature help (if signature.enabled = true)
  --
  -- See :h blink-cmp-config-keymap for defining your own keymap
  keymap = { preset = 'default' },
  appearance = {
    nerd_font_variant = 'mono',
  },
  completion = {
    documentation = { auto_show = false },
    accept = { auto_brackets = { enabled = false } },
    menu = {
      draw = {
        columns = {
          { 'kind_icon', 'label', 'label_description', 'source_name', gap = 1 },
        },
        components = {
          label_description = {
            width = { max = 80 },
            text = function(ctx)
              if ctx.item and ctx.item.detail then
                return ctx.item.detail
              end
              return ctx.label_description or ''
            end,
          },
          source_name = {
            text = function(ctx)
              return '[' .. ctx.source_name .. ']'
            end,
          },
        },
      },
    },
  },
  signature = { enabled = true },
  cmdline = {
    keymap = { preset = 'inherit' },
    completion = {
      menu = {
        auto_show = true,
      },
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
}

