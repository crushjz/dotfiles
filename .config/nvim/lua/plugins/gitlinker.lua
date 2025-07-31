require('gitlinker').setup {
  mappings = nil, -- disable default mappings
  callbacks = {
    ['gitlab.qonto.co'] = require('gitlinker.hosts').get_gitlab_type_url,
    ['github.com'] = function(url_data)
      if url_data.host == 'github.com-qonto' then
        url_data.host = 'github.com'
      end
      return require('gitlinker.hosts').get_github_type_url(url_data)
    end,
  },
}

vim.api.nvim_set_keymap(
  'n',
  '<leader>gy',
  '<cmd>lua require"gitlinker".get_buf_range_url("n")<cr>',
  { silent = true, desc = 'Copy Git remote URL for current line to clipboard' }
)
vim.api.nvim_set_keymap(
  'v',
  '<leader>gy',
  '<cmd>lua require"gitlinker".get_buf_range_url("v")<cr>',
  { desc = 'Copy Git remote URL for selected lines to clipboard' }
)

vim.api.nvim_set_keymap(
  'n',
  '<leader>go',
  '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
  { silent = true, desc = 'Open Git remote URL for current line in browser' }
)
vim.api.nvim_set_keymap(
  'v',
  '<leader>go',
  '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
  { desc = 'Open Git remote URL for selected lines in browser' }
)
