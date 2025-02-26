require('nvim-tree').setup {
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
