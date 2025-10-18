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
