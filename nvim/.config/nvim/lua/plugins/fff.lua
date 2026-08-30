require('fff').setup({
  prompt_vim_mode = false,
  layout = {
    prompt_position = 'top',
  },
  grep = {
    smart_case = true,
    modes = { 'plain', 'regex', 'fuzzy' },
  },
  frecency = { enabled = true },
  history = { enabled = true },
})

local fff = require('fff')

vim.keymap.set('n', '<leader>ss', fff.find_files, { desc = '[s]earch files (fff)' })
vim.keymap.set('n', '<leader>S', fff.live_grep, { desc = '[S]earch by grep (fff)' })
vim.keymap.set('n', 'fc',
  function() fff.live_grep({ query = vim.fn.expand('<cword>') }) end,
  { desc = 'FFF search current word' })
