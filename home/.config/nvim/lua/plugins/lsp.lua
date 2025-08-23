local servers = {
  'astro',
  'lua_ls',
  'gopls',
  'phpactor',
  'vtsls',
  'jq-lsp',
  'jsonls',
  'html',
  'emmet_ls',
  'cssls',
  'biome',
  'eslint',
}

return {
  'mason-org/mason-lspconfig.nvim',
  opts = {
    ensure_installed = servers,
  },
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'neovim/nvim-lspconfig',
    'saghen/blink.cmp',
    { 'j-hui/fidget.nvim', opts = {} },
  },

  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    for _, lsp in pairs(servers) do
      vim.lsp.config[lsp] = { capabilities = capabilities }
    end

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = {
            globals = { 'vim', 'require' },
          },
          telemetry = { enable = false },
        },
      },
    })

    vim.lsp.config('vtsls', {
      root_markers = {
        'tsconfig.json',
        'jsconfig.json',
        '!deno.json',
        '!deno.jsonc',
      },
      single_file_support = false,
    })

    vim.lsp.enable(servers)
  end,
}
