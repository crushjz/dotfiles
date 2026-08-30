require('smart-splits').setup({
  -- Ignored buffer types (won't resize/move)
  ignored_buftypes = {
    'NvimTree',
  },
  -- Ignored filetypes (won't resize/move)
  ignored_filetypes = {
    'NvimTree',
  },
  -- the default number of lines/columns to resize by at a time
  default_amount = 3,
  -- Whether to wrap at edges (use 'wrap', 'split', or 'stop')
  -- 'stop' prevents wrapping to avoid confusion
  at_edge = 'stop',
  -- When moving cursor, move to same row or column (true = same row for horizontal movements)
  move_cursor_same_row = true,
  -- resize mode options
  resize_mode = {
    -- silent = don't show notifications during resize
    silent = true,
    -- hooks to run when entering/exiting resize mode
    hooks = {
      on_enter = nil,
      on_leave = nil,
    },
  },
  -- tmux integration settings
  multiplexer_integration = 'tmux',
})
