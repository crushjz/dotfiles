require('lualine').setup {
  options = {
    theme = 'everforest',
  },
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1,
      },
    },
  },
}
