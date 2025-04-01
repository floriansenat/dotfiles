local servers = {
  'lua_ls',
  'gopls',
  'phpactor',
  'denols',
  'vtsls',
  'jsonls',

  -- Front only
  'html',
  'emmet_ls',
  'cssls',
  'astro',

  -- Format & Lint
  'biome',
  'eslint',
}

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'saghen/blink.cmp',
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    require('mason').setup()
    require('mason-lspconfig').setup {
      ensure_installed = servers,
    }

    local lspconfig = require 'lspconfig'
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local on_attach = function()
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })
      vim.keymap.set('n', 'g.', vim.lsp.buf.code_action, { desc = '[A]ctions' })
      vim.keymap.set('n', 'gr', vim.lsp.buf.rename, { desc = '[R]ename' })
    end

    for _, lsp in pairs(servers) do
      lspconfig[lsp].setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }
    end

    lspconfig.vtsls.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = lspconfig.util.root_pattern 'tsconfig.json',
      'jsconfig.json',
      '!deno.json',
      '!deno.jsonc',
      single_file_support = false,
    }
    lspconfig.denols.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = lspconfig.util.root_pattern 'deno.json',
      'deno.jsonc',
    }
    lspconfig.biome.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = lspconfig.util.root_pattern 'biome.json',
    }
    lspconfig.lua_ls.setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          yorkspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    }

    vim.filetype.add {
      extension = { astro = 'astro' },
    }
  end,
}
