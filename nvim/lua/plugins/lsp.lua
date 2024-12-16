local SERVERS = {
  'lua_ls',
  'denols',
  'gopls',
  'phpactor',
  'vtsls',
  'jsonls',
  'biome',
  'eslint',
  'html',
  'emmet_ls',
  'cssls',
}

return {
  { 'williamboman/mason.nvim', lazy = false, opts = {} },
  { 'williamboman/mason-lspconfig.nvim', lazy = false, opts = { ensure_installed = SERVERS } },
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = { { 'j-hui/fidget.nvim', opts = {} }, 'folke/lazydev.nvim' },
    config = function()
      local lspconfig = require 'lspconfig'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      for _, lsp in pairs(SERVERS) do
        lspconfig[lsp].setup { capabilities = capabilities }
      end

      lspconfig.denols.setup {
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern 'deno.json',
        'deno.jsonc',
      }
      lspconfig.biome.setup {
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern 'biome.json',
      }
      lspconfig.vtsls.setup {
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern 'package.json',
        'tsconfig.json',
        'jsconfig.json',
        single_file_support = false,
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
    end,
  },
}
