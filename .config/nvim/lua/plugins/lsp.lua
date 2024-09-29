local vim = vim

require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = { 'lua_ls', 'ts_ls', 'eslint', 'stylelint_lsp' },
}

local function add_desc(base_opts, desc)
  local copy = {}
  for k, v in pairs(base_opts) do
    copy[k] = v
  end
  copy.desc = desc
  return copy
end

-- Assume `client` is your LSP client object
local function is_document_highlight_supported(client)
  return client.server_capabilities.documentHighlightProvider == true
end

local function is_highlight_supported_on_ft(ft)
  return ft == 'javascript' or ft == 'typescript' or ft == 'javascriptreact' or ft == 'typescriptreact' or ft == 'lua'
end

local lspconfig = require 'lspconfig'

local function on_attach(client, bufnr)
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

  -- Document highlight on cursor hold
  if is_document_highlight_supported(client) then
    local group = vim.api.nvim_create_augroup('LspDocumentHighlight', { clear = true })
    vim.api.nvim_create_autocmd({ 'CursorHold' }, {
      group = group,
      callback = function()
        if is_highlight_supported_on_ft(vim.bo.filetype) then
          vim.lsp.buf.document_highlight()
        end
      end,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
      group = group,
      callback = function()
        if is_highlight_supported_on_ft(vim.bo.filetype) then
          vim.lsp.buf.clear_references()
        end
      end,
    })
  end
end

-- TypeScript / JavaScript
lspconfig.ts_ls.setup {
  on_attach = on_attach,
}

-- Eslint
lspconfig.eslint.setup {
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'EslintFixAll',
    })
  end,
}

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

-- Lua
lspconfig.lua_ls.setup {
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
  on_attach = on_attach,
  settings = {
    Lua = {},
  },
}
