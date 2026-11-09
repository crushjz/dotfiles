require('smart-splits').setup({
  -- Ignored buffer types (won't resize/move)
  ignored_buftypes = {
    'NvimTree',
  },
  -- Ignored filetypes (won't resize/move)
  ignored_filetypes = {
    'NvimTree',
  },
  resize = {
    -- the default number of lines/columns to resize by at a time
    amount = 3,
  },
  move = {
    -- 'stop' prevents wrapping to avoid confusion
    at_edge = 'stop',
    -- Keep the cursor on the same screen row when moving horizontally
    same_row = true,
  },
  -- tmux integration settings
  mux = {
    backend = 'tmux',
  },
})
