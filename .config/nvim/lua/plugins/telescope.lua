local function filename_first(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == '.' then
    return tail
  end
  return string.format('%s\t\t%s', tail, parent)
end

require('telescope').setup {
  defaults = {
    sorting_strategy = 'ascending',
    layout_config = {
      prompt_position = 'top',
    },
    mappings = {
      i = {
        ['<C-h>'] = 'which_key',
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
      path_display = filename_first,
    },
    live_grep = {
      additional_args = {
        '--hidden',
        '--glob',
        '!**/.git/*',
      },
      -- mappings = {
      --   i = {
      --     ['<c-f>'] = custom_pickers.actions.set_extension,
      --     ['<c-l>'] = custom_pickers.actions.set_folders,
      --   },
      -- },
    },
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  },
}

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>s', builtin.find_files, { desc = '[S]earch files' })
vim.keymap.set('n', '<leader>S', builtin.live_grep, { desc = '[S]earch by grep' })
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
