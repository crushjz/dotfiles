require('gitsigns').setup {
  current_line_blame = true,
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Next hunk' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Previous hunk' })

    -- Actions
    map('n', '<leader>us', gitsigns.stage_hunk, { desc = 'Stage hunk' })
    map('n', '<leader>ur', gitsigns.reset_hunk, { desc = 'Reset hunk' })
    map('v', '<leader>us', function()
      gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'Stage hunk' })
    map('v', '<leader>ur', function()
      gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'Reset hunk' })
    map('n', '<leader>uS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
    map('n', '<leader>uu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })
    map('n', '<leader>uR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
    map('n', '<leader>up', gitsigns.preview_hunk, { desc = 'Preview hunk' })
    -- map('n', '<leader>ub', function()
    --   gitsigns.blame_line { full = true }
    -- end)
    map('n', '<leader>ub', gitsigns.toggle_current_line_blame)
    map('n', '<leader>ud', gitsigns.diffthis, { desc = 'Diff this' })
    map('n', '<leader>uD', function()
      gitsigns.diffthis '~'
    end, { desc = 'Diff this ~' })
    map('n', '<leader>td', gitsigns.toggle_deleted, { desc = 'Toggle deleted' })

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
  end,
}
