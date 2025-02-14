require('CopilotChat').setup {}

vim.keymap.set('n', '<leader>ct', ':CopilotToggle<CR>', { desc = '[C]opilot [T]oggle' })
vim.keymap.set('n', '<leader>cb', ':CopilotChatBuffer<CR>', { desc = '[C]opilot Chat with current [B]uffer' })
vim.keymap.set('n', '<leader>cc', ':CopilotChatOpen<CR>', { desc = '[C]opilot [C]hat' })

-- Disable Copilot by default
vim.cmd 'Copilot disable'
local copilot_enabled = false
vim.api.nvim_create_user_command('CopilotToggle', function()
  if copilot_enabled then
    vim.cmd 'Copilot disable'
    copilot_enabled = false
  else
    vim.cmd 'Copilot enable'
    copilot_enabled = true
  end
end, {})
