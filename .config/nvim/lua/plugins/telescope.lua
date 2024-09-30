local custom_pickers = require 'plugins.telescope-pickers'

local function filename_first(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == '.' then
    return tail
  end
  return string.format('%s\t\t%s', tail, parent)
end

local actions = require 'telescope.actions'
local actions_layout = require 'telescope.actions.layout'

require('telescope').setup {
  defaults = {
    sorting_strategy = 'ascending',
    layout_config = {
      prompt_position = 'top',
    },
    mappings = {
      i = {
        ['<C-h>'] = 'which_key',
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['?'] = actions_layout.toggle_preview,
      },
      n = {
        ['?'] = actions_layout.toggle_preview,
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
      mappings = {
        i = {
          ['<C-f>'] = custom_pickers.actions.set_extension,
          ['<C-l>'] = custom_pickers.actions.set_folders,
        },
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case". Default is "smart_case"
    },
  },
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension 'fzf'

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>s', builtin.find_files, { desc = '[S]earch files' })
vim.keymap.set('n', '<leader>S', builtin.live_grep, { desc = '[S]earch by grep' })
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
