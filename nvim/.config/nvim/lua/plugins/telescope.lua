local custom_pickers = require 'plugins.telescope-pickers'

local utils = require 'plugins.telescope-utils'

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
        -- ['<C-h>'] = 'which_key',
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['?'] = actions_layout.toggle_preview,
        ['<C-n>'] = actions.cycle_history_next,
        ['<C-p>'] = actions.cycle_history_prev,
      },
      n = {
        ['?'] = actions_layout.toggle_preview,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = utils.find_command,
      path_display = utils.filename_first,
      mappings = {
        i = {
          ['<C-l>'] = custom_pickers.actions.set_search_dir,
        },
      },
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
    colorscheme = {
      enable_preview = true,
      layout_strategy = 'vertical',
      layout_config = {
        vertical = {
          width = 0.5, -- Set the width to 50% of the screen
          anchor = 'E', -- Align to the right
        },
        height = 0.9, -- Optionally set the height to 90% of the screen
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
-- vim.keymap.set('n', '<leader>ss', builtin.find_files, { desc = '[s]earch files' })  -- temporarily replaced by fff
-- vim.keymap.set('n', '<leader>S', builtin.live_grep, { desc = '[S]earch by grep' })  -- temporarily replaced by fff
vim.keymap.set('n', '<leader>sw', builtin.oldfiles, { desc = 'Search [W]oldfiles' })
vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = 'Search [B]uffers' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search [H]elp tags' })
vim.keymap.set('n', '<leader>sg', builtin.git_status, { desc = 'Search [G]it files' })
vim.keymap.set('n', '<leader>sc', builtin.colorscheme, { desc = 'Search [C]olorscheme' })
