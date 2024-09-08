require('nvim-possession').setup {
  autoload = false, -- whether to autoload sessions in the cwd at startup
  autosave = true, -- whether to autosave loaded sessions before quitting
  autoswitch = {
    enable = false, -- whether to enable autoswitch
    exclude_ft = {}, -- list of filetypes to exclude from autoswitch
  },
}

local possession = require 'nvim-possession'
vim.keymap.set('n', '<leader>hl', function()
  possession.list()
end, { desc = 'List all sessions' })
vim.keymap.set('n', '<leader>hn', function()
  possession.new()
end, { desc = 'Create a new session' })
vim.keymap.set('n', '<leader>hu', function()
  possession.update()
end, { desc = 'Update the current session' })
vim.keymap.set('n', '<leader>hd', function()
  possession.delete()
end, { desc = 'Delete the current session' })
