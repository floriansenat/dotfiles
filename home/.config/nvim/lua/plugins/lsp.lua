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

    for _, lsp in pairs(servers) do
      lspconfig[lsp].setup {
        capabilities = capabilities,
      }
    end

    lspconfig.vtsls.setup {
      capabilities = capabilities,
      root_dir = lspconfig.util.root_pattern 'tsconfig.json',
      'jsconfig.json',
      '!deno.json',
      '!deno.jsonc',
      single_file_support = false,
    }
    lspconfig.denols.setup {
      capabilities = capabilities,
      root_dir = lspconfig.util.root_pattern 'deno.json',
      'deno.jsonc',
    }
    lspconfig.biome.setup {
      capabilities = capabilities,
      root_dir = lspconfig.util.root_pattern 'biome.json',
    }
    lspconfig.lua_ls.setup {
      capabilities = capabilities,
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
