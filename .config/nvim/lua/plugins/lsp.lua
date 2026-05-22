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

local function on_ts_ls_attach(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, add_desc(opts, 'Go to definition'))
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, add_desc(opts, 'Hover'))
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, add_desc(opts, 'Go to implementation'))
  vim.keymap.set('n', 'gs', vim.lsp.buf.rename, add_desc(opts, 'Rename'))
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, add_desc(opts, 'References'))
  vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, add_desc(opts, 'Code action'))
  vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump({ count = -1 })
    vim.defer_fn(function()
      vim.diagnostic.open_float()
    end, 10)
  end, add_desc(opts, 'Jump to the previous diagnostic'))
  vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump({ count = 1 })
    vim.defer_fn(function()
      vim.diagnostic.open_float()
    end, 10)
  end, add_desc(opts, 'Jump to the next diagnostic'))
  vim.keymap.set('n', 'gq', vim.diagnostic.setqflist, add_desc(opts, 'Add all diagnostics to the quickfix list'))
end

local capabilities = require('blink.cmp').get_lsp_capabilities()

-- TypeScript / JavaScript
vim.lsp.enable 'ts_ls'
vim.lsp.config('ts_ls', {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  on_attach = on_ts_ls_attach,
  capabilities = capabilities,
})

vim.lsp.enable 'ember'

-- Eslint
vim.lsp.enable 'eslint'

local base_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config('eslint', {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  on_attach = function(client, bufnr)
    if not base_on_attach then
      return
    end

    base_on_attach(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'Format', -- Only run conform.format
    })
  end,
})

-- OXC (oxlint language server — diagnostics only, no hover/definition/completion)
-- Only starts when oxlint is installed in the project's node_modules
vim.lsp.enable 'oxlint'
vim.lsp.config('oxlint', {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  cmd = function(dispatchers)
    local bin = vim.fn.findfile('node_modules/.bin/oxlint', vim.fn.getcwd() .. ';')
    if bin == '' then
      return nil
    end
    return vim.lsp.rpc.start({ bin, '--lsp' }, dispatchers)
  end,
})

vim.lsp.enable 'cssmodules_ls'
vim.lsp.config('cssmodules_ls', {})

vim.lsp.enable 'stylelint_lsp'
vim.lsp.config('stylelint_lsp', {
  filetypes = { 'css', 'less', 'scss', 'vue' },
})

-- CSS Language Server
vim.lsp.enable 'cssls'
vim.lsp.config('cssls', {
  filetypes = { 'css', 'scss', 'less' },
})

-- Emmet
vim.lsp.enable 'emmet_language_server'
vim.lsp.config('emmet_language_server', {
  filetypes = { 'html', 'javascriptreact', 'typescriptreact', 'handlebars' },
})

-- Zig
vim.lsp.enable 'zls'
vim.lsp.config('zls', {
  filetypes = { 'zig' },
  on_attach = on_ts_ls_attach,
})

-- Lua
vim.lsp.enable 'lua_ls'
vim.lsp.config('lua_ls', {
  filetypes = { 'lua' },
  on_attach = on_ts_ls_attach,
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library'
          -- '${3rd}/busted/library'
        },
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      },
    })
  end,
  settings = {
    Lua = {},
  },
})
