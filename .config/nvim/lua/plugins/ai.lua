-- Disable Copilot by default
vim.g.copilot_enabled = false
local copilot_enabled = false
vim.api.nvim_create_user_command('CopilotToggle', function()
  if copilot_enabled then
    vim.cmd 'Copilot disable'
  else
    vim.cmd 'Copilot enable'
  end
  copilot_enabled = not copilot_enabled
end, {})

vim.keymap.set('n', '<leader>ct', ':CopilotToggle<CR>', { desc = 'Copilot [T]oggle' })

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

-- vim.keymap.set('n', '<leader>aa', function()
