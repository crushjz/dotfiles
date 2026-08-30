-- Install required parsers
require('nvim-treesitter').install({
  'lua',
  'yaml',
  'dockerfile',
  'vim',
  'vimdoc',
  'query',
  'markdown',
  'markdown_inline',
  'javascript',
  'typescript',
  'tsx',
  'html',
  'css',
  'glimmer',
})

-- Enable treesitter highlighting for supported filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'lua',
    'yaml',
    'dockerfile',
    'vim',
    'vimdoc',
    'query',
    'markdown',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'html',
    'css',
    'glimmer',
    'handlebars',
  },
  callback = function()
    vim.treesitter.start()
  end,
  desc = 'Enable treesitter highlighting',
})

-- Enable treesitter-based folding for supported filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'lua',
    'yaml',
    'dockerfile',
    'vim',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'html',
    'css',
    'glimmer',
  },
  callback = function()
    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
  desc = 'Enable treesitter folding',
})

-- Textobjects: Select
local select = require 'nvim-treesitter-textobjects.select'

-- Assignment textobjects
vim.keymap.set({ 'x', 'o' }, 'a=', function()
  select.select_textobject('@assignment.outer', 'textobjects')
end, { desc = 'Select outer part of an assignment' })
vim.keymap.set({ 'x', 'o' }, 'i=', function()
  select.select_textobject('@assignment.inner', 'textobjects')
end, { desc = 'Select inner part of an assignment' })
vim.keymap.set({ 'x', 'o' }, 'l=', function()
  select.select_textobject('@assignment.lhs', 'textobjects')
end, { desc = 'Select left hand side of an assignment' })
vim.keymap.set({ 'x', 'o' }, 'r=', function()
  select.select_textobject('@assignment.rhs', 'textobjects')
end, { desc = 'Select right hand side of an assignment' })

-- Parameter/argument textobjects
vim.keymap.set({ 'x', 'o' }, 'aa', function()
  select.select_textobject('@parameter.outer', 'textobjects')
end, { desc = 'Select outer part of a parameter/argument' })
vim.keymap.set({ 'x', 'o' }, 'ia', function()
  select.select_textobject('@parameter.inner', 'textobjects')
end, { desc = 'Select inner part of a parameter/argument' })

-- Conditional textobjects
vim.keymap.set({ 'x', 'o' }, 'ai', function()
  select.select_textobject('@conditional.outer', 'textobjects')
end, { desc = 'Select outer part of a conditional' })
vim.keymap.set({ 'x', 'o' }, 'ii', function()
  select.select_textobject('@conditional.inner', 'textobjects')
end, { desc = 'Select inner part of a conditional' })

-- Loop textobjects
vim.keymap.set({ 'x', 'o' }, 'al', function()
  select.select_textobject('@loop.outer', 'textobjects')
end, { desc = 'Select outer part of a loop' })
vim.keymap.set({ 'x', 'o' }, 'il', function()
  select.select_textobject('@loop.inner', 'textobjects')
end, { desc = 'Select inner part of a loop' })

-- Function call textobjects
vim.keymap.set({ 'x', 'o' }, 'af', function()
  select.select_textobject('@call.outer', 'textobjects')
end, { desc = 'Select outer part of a function call' })
vim.keymap.set({ 'x', 'o' }, 'if', function()
  select.select_textobject('@call.inner', 'textobjects')
end, { desc = 'Select inner part of a function call' })

-- Function definition textobjects
vim.keymap.set({ 'x', 'o' }, 'am', function()
  select.select_textobject('@function.outer', 'textobjects')
end, { desc = 'Select outer part of a method/function definition' })
vim.keymap.set({ 'x', 'o' }, 'im', function()
  select.select_textobject('@function.inner', 'textobjects')
end, { desc = 'Select inner part of a method/function definition' })

-- Class textobjects
vim.keymap.set({ 'x', 'o' }, 'ac', function()
  select.select_textobject('@class.outer', 'textobjects')
end, { desc = 'Select outer part of a class' })
vim.keymap.set({ 'x', 'o' }, 'ic', function()
  select.select_textobject('@class.inner', 'textobjects')
end, { desc = 'Select inner part of a class' })

-- Textobjects: Move
local move = require 'nvim-treesitter-textobjects.move'

vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
  move.goto_next_start('@function.outer', 'textobjects')
end, { desc = 'Next function start' })
vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
  move.goto_previous_start('@function.outer', 'textobjects')
end, { desc = 'Previous function start' })
vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
  move.goto_next_start('@fold', 'folds')
end, { desc = 'Next fold' })
vim.keymap.set({ 'n', 'x', 'o' }, '[z', function()
  move.goto_previous_start('@fold', 'folds')
end, { desc = 'Previous fold' })
