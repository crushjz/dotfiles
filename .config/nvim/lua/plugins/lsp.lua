local vim = vim

require('mason').setup()

local function add_desc(base_opts, desc)
  local copy = {}
  for k, v in pairs(base_opts) do
    copy[k] = v
  end
  copy.desc = desc
  return copy
end

local lspconfig = require 'lspconfig'

local function on_ts_ls_attach(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, add_desc(opts, 'Go to definition'))
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, add_desc(opts, 'Hover'))
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, add_desc(opts, 'Go to implementation'))
  vim.keymap.set('n', 'gs', vim.lsp.buf.rename, add_desc(opts, 'Rename'))
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, add_desc(opts, 'References'))
  vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, add_desc(opts, 'Code action'))
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, add_desc(opts, 'Jump to the previous diagnostic'))
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, add_desc(opts, 'Jump to the next diagnostic'))
  vim.keymap.set('n', 'gq', vim.diagnostic.setqflist, add_desc(opts, 'Add all diagnostics to the quickfix list'))

end


-- TypeScript / JavaScript
lspconfig.ts_ls.setup {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  on_attach = on_ts_ls_attach,
}

lspconfig.ember.setup {}

-- Eslint
lspconfig.eslint.setup {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd('BufWritePost', {
      callback = function()
        vim.cmd 'Format'
      end,
    })
  end,
}

lspconfig.cssmodules_ls.setup({})

lspconfig.stylelint_lsp.setup {
  filetypes = {
    'css',
    'less',
    'scss',
    'sugarss',
    'vue',
    'wxss',
  },
}

-- Emmet
lspconfig.emmet_language_server.setup {
  filetypes = { 'html', 'javascriptreact', 'typescriptreact', 'handlebars' },
}

-- Zig
lspconfig.zls.setup {
  filetypes = { 'zig' },
  on_attach = on_ts_ls_attach,
}

-- Lua
lspconfig.lua_ls.setup {
  filetypes = { 'lua' },
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      return
    end

    -- Enable Vim/Neovim global variables
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        },
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      },
    })
  end,
  on_attach = on_ts_ls_attach,
  settings = {
    Lua = {},
  },
}
