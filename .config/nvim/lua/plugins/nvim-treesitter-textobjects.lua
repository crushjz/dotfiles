local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

require('nvim-treesitter.configs').setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
        ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
        ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
        ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },

        ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
        ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },

        ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
        ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },

        ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
        ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },

        ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
        ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },

        ['am'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
        ['im'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },

        ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
        ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']]'] = { query = '@class.outer', desc = 'Next class start' },
        [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
      },
      goto_next_end = {
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[]'] = '@class.outer',
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      goto_next = {
        [']m'] = '@function.outer',
      },
      goto_previous = {
        ['[m'] = '@function.outer',
      },
    },
  },
}

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)
