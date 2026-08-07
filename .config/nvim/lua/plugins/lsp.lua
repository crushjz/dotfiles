local vim = vim

require('mason').setup()

local capabilities = require('blink.cmp').get_lsp_capabilities()

-- Global LSP settings (applied to all servers)
vim.lsp.config('*', {
  capabilities = capabilities,
})

-- LspAttach autocmd — set keymaps once for all servers
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function()
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { desc = 'Go to type definition' })
    vim.keymap.set('n', 'gR', function() require('telescope.builtin').lsp_references() end, { desc = 'References' })
    vim.keymap.set('n', 'gs', vim.lsp.buf.rename, { desc = 'Rename' })
    vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, { desc = 'Code action' })
    vim.keymap.set('n', '[d', function()
      vim.diagnostic.jump({ count = -1 })
      vim.defer_fn(function()
        vim.diagnostic.open_float()
      end, 10)
    end, { desc = 'Jump to the previous diagnostic' })
    vim.keymap.set('n', ']d', function()
      vim.diagnostic.jump({ count = 1 })
      vim.defer_fn(function()
        vim.diagnostic.open_float()
      end, 10)
    end, { desc = 'Jump to the next diagnostic' })
    vim.keymap.set('n', 'gq', vim.diagnostic.setqflist, { desc = 'Add all diagnostics to the quickfix list' })
  end,
})


vim.lsp.enable 'tsgo'

vim.lsp.enable 'ember'

-- Eslint
-- vim.lsp.enable 'eslint'
-- vim.lsp.config('eslint', {
--   filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
--   on_attach = function(client, bufnr)
--     vim.api.nvim_create_autocmd('BufWritePre', {
--       buffer = bufnr,
--       command = 'Format',
--     })
--   end,
-- })

-- OXC (oxlint language server — diagnostics only, no hover/definition/completion)
-- lspconfig's builtin roots at the nearest .oxlintrc.json, which spawns one server
-- per package in a monorepo. Root at the repo instead: oxlint resolves nested
-- .oxlintrc.json itself, so one server covers everything.
vim.lsp.enable 'oxlint'
vim.lsp.config('oxlint', {
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, { 'pnpm-lock.yaml', 'package-lock.json', 'yarn.lock', 'bun.lock', '.git' }))
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
vim.lsp.config('zls', {})

-- Lua
vim.lsp.enable 'lua_ls'
vim.lsp.config('lua_ls', {
  filetypes = { 'lua' },
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    })
  end,
  settings = {
    Lua = {},
  },
})
