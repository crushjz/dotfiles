local vim = vim
local Plug = vim.fn['plug#']

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Enable 256 colors
vim.o.termguicolors = true

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 15

-- Set the number of spaces a <Tab> counts for
vim.opt.tabstop = 2

-- Set the number of spaces to use for each step of (auto)indent
vim.opt.shiftwidth = 2

-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Enable auto-indent
vim.opt.smartindent = true

-- Enable folding (default to indent, treesitter folds set per-filetype)
vim.o.foldmethod = 'indent'
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- disable netrw at the very start of your init.lua (required for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Split (for some reason we need to specify the Shift key)
vim.keymap.set('n', '<C-S-l>', ':vsplit<CR>', { desc = 'Split vertically' })
vim.keymap.set('n', '<C-S-j>', ':split<CR>', { desc = 'Split horizontally' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', function() require('smart-splits').move_cursor_left() end,
  { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', function() require('smart-splits').move_cursor_right() end,
  { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', function() require('smart-splits').move_cursor_down() end,
  { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', function() require('smart-splits').move_cursor_up() end,
  { desc = 'Move focus to the upper window' })

-- Close current buffer
vim.keymap.set('n', '<C-q>', ':q<CR>', { desc = 'Close current buffer' })

-- Resize panes using Ctrl-Alt + hjkl
--
-- Requires iterm2 setting: Profiles -> Keys -> Change Left Option key & Right Option key from normal to Esc+
-- Requires kitty setting: macos_option_as_alt yes
-- Requires ghostty: macos-option-as-alt=true
-- Requires tmux: extended-keys on
vim.keymap.set('n', '<C-M-h>', function() require('smart-splits').resize_left() end,
  { noremap = true, silent = true, desc = 'Resize split left' })
vim.keymap.set('n', '<C-M-j>', function() require('smart-splits').resize_down() end,
  { noremap = true, silent = true, desc = 'Resize split down' })
vim.keymap.set('n', '<C-M-k>', function() require('smart-splits').resize_up() end,
  { noremap = true, silent = true, desc = 'Resize split up' })
vim.keymap.set('n', '<C-M-l>', function() require('smart-splits').resize_right() end,
  { noremap = true, silent = true, desc = 'Resize split right' })


-- Move between buffers
-- vim.api.nvim_set_keymap('n', '[[', ':bprev<CR>', { desc = 'Previous buffer', noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', ']]', ':bnext<CR>', { desc = 'Next buffer', noremap = true, silent = true })

-- Quickfix list: move next/prev
vim.keymap.set('n', ']q', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '[q', '<cmd>cprev<CR>zz')

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Register filetypes not built into Neovim
vim.filetype.add {
  extension = {
    hbs = 'handlebars',
    gts = 'typescript.glimmer',
    gjs = 'javascript.glimmer',
  },
}

--------------------------------------------------------------------------------
-- [[ Plugins ]]
vim.call 'plug#begin'

-- Dependencies
-- Requires a Nerd Font to be installed on the system (https://github.com/ryanoasis/nerd-fonts)
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
-- Requires fzf to be installed on the system
Plug 'ibhagwan/fzf-lua'

-- Plugins
Plug 'stevearc/conform.nvim'
Plug 'ruifm/gitlinker.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'echasnovski/mini.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'folke/sidekick.nvim'
Plug('nvim-treesitter/nvim-treesitter', { ['branch'] = 'main', ['do'] = ':TSUpdate' })
Plug('nvim-treesitter/nvim-treesitter-textobjects', { ['branch'] = 'main' })
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'folke/ts-comments.nvim'
Plug 'mrjones2014/smart-splits.nvim'
Plug('nvim-telescope/telescope.nvim', { ['branch'] = 'master' })
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })
Plug 'nvim-lualine/lualine.nvim'
Plug 'folke/which-key.nvim'
Plug('kevinhwang91/nvim-bqf', { ['for'] = 'qf' })
Plug 'kylechui/nvim-surround'
Plug 'windwp/nvim-autopairs'
Plug('ThePrimeagen/harpoon', { ['branch'] = 'harpoon2' })
Plug 'https://codeberg.org/andyg/leap.nvim'
Plug 'folke/zen-mode.nvim'
Plug 'OXY2DEV/markview.nvim'
Plug 'ziglang/zig.vim'
-- Completion
Plug('saghen/blink.cmp', { ['tag'] = 'v1.*' })

-- Colorschemes
Plug 'sainnhe/everforest'
Plug 'tinted-theming/tinted-vim'

vim.call 'plug#end'

--------------------------------------------------------------------------------

vim.cmd [[colorscheme base16-gruvbox-dark-medium]]
-- vim.cmd [[colorscheme base16-gruvbox-light-hard]]
require 'plugins.telescope'
require 'plugins.conform'
require 'plugins.git'
require 'plugins.gitlinker'
require 'plugins.lsp'
require 'plugins.nvim-tree'
require 'plugins.nvim-treesitter'
require 'plugins.lualine'
require 'plugins.completion'
require 'plugins.ai'
require 'plugins.surround'
require 'plugins.which-key'
require 'plugins.autopairs'
require 'plugins.harpoon'
require 'plugins.leap-vim'
require 'plugins.zen-mode'
require 'plugins.markview'
require 'plugins.smart-splits'
require 'plugins.ts-comments'
