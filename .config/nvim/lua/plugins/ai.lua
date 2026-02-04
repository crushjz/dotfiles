require('sidekick').setup {
  cli = {
    mux = {
      backend = 'tmux',
      enabled = false,
    },
  },
  nes = {
    enabled = false,
  },
}

vim.keymap.set('n', '<leader>cc', ':Sidekick cli toggle<CR>', { desc = 'Sidekick CLI [C]hat toggle' })
vim.keymap.set({ 'n', 'x' }, '<leader>cp', ':Sidekick cli prompt<CR>', { desc = 'Sidekick CLI [P]rompt' })

