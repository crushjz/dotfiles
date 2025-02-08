local ss = require('smart-splits')
ss.setup()

-- resizing splits
vim.keymap.set('n', '<C-M-h>', ss.resize_left)
vim.keymap.set('n', '<C-M-j>', ss.resize_down)
vim.keymap.set('n', '<C-M-k>', ss.resize_up)
vim.keymap.set('n', '<C-M-l>', ss.resize_right)
-- moving between splits
vim.keymap.set('n', '<C-h>', ss.move_cursor_left)
vim.keymap.set('n', '<C-j>', ss.move_cursor_down)
vim.keymap.set('n', '<C-k>', ss.move_cursor_up)
vim.keymap.set('n', '<C-l>', ss.move_cursor_right)
