require('lualine').setup {
  options = {
    theme = 'everforest',
  },
  sections = {
    lualine_b = {
      'diff',
      'diagnostic',
    },
    lualine_c = {
      {
        'filename',
        path = 1,
      },
    },
  },
}
