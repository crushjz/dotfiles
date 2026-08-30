require('nvim-tree').setup {
  view = {
    preserve_window_proportions = true,
    width = {
      min = 30,
      max = 55,
      padding = 1,
    },
  },
  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
    ignore_dirs = {
      '.git',
      'node_modules',
    },
  },
  filters = {
    custom = { '^\\.git$' },
  },
}

vim.keymap.set('n', '<leader><leader>', ':NvimTreeFindFile<CR>', { desc = 'Open NvimTree and focus the file in the current bufname' })
