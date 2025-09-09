require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'isort', 'black' },
    rust = { 'rustfmt', lsp_format = 'fallback' },
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    yaml = { 'prettier' },
    css = { 'prettier' },
    html = { 'prettier' },
    handlebars = { 'prettier' },
    json = { 'prettier' },
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
  require('conform').format { async = true, lsp_format = 'fallback', range = range }
end

vim.api.nvim_create_user_command('Format', function(args)
  format_buffer_or_range(args)
end, { range = true })

vim.api.nvim_create_user_command('FormatAndLint', function(args)
  format_buffer_or_range(args)
  local ft = vim.bo.filetype
  if ft == 'javascript' or ft == 'javascriptreact' or ft == 'typescript' or ft == 'typescriptreact' then
    vim.cmd 'EslintFixAll'
  end
end, { range = true })

-- Format key binding
vim.keymap.set('n', '<leader>f', ':FormatAndLint<CR>', { desc = 'Format and EslintFixAll buffer' })
