local wk = require 'which-key'

wk.setup {}

wk.add {
  { '<leader>s', group = '[S]earch' },
  { '<leader>h', group = 'Session [H]istory' },
  { '<leader>u', group = 'Git' },
  { '<leader>c', group = 'Copilot'}
}
