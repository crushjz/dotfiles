require('lualine').setup {
  options = {
    theme = 'gruvbox_dark',
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
