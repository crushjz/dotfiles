require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'isort', 'black' },
    rust = { 'rustfmt', lsp_format = 'fallback' },
    javascript = { 'oxfmt', 'prettier', stop_after_first = true },
    javascriptreact = { 'oxfmt', 'prettier', stop_after_first = true },
    typescript = { 'oxfmt', 'prettier', stop_after_first = true },
    typescriptreact = { 'oxfmt', 'prettier', stop_after_first = true },
    yaml = { 'prettier' },
    css = { 'prettier' },
    html = { 'prettier' },
    handlebars = { 'prettier' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    markdown = { 'prettier' },
    zig = { 'zigfmt' },
  },
}

local function format_buffer_or_range(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ['end'] = { args.line2, end_line:len() },
    }
  end
  require('conform').format { async = false, lsp_format = 'fallback', range = range }
end

vim.api.nvim_create_user_command('Format', function(args)
  format_buffer_or_range(args)
end, { range = true })

vim.api.nvim_create_user_command('FormatAndLint', function(args)
  format_buffer_or_range(args)
  if #vim.lsp.get_clients({ name = 'oxlint', bufnr = 0 }) > 0 then
    vim.cmd 'LspOxlintFixAll'
  end
end, { range = true })

-- Format key binding
vim.keymap.set('n', '<leader>f', ':FormatAndLint<CR>', { desc = 'Format and EslintFixAll buffer' })
