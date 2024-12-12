return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'biome', 'prettier' },
      javascriptreact = { 'biome', 'prettier' },
      typescript = { 'biome', 'prettier' },
      typescriptreact = { 'biome', 'prettier' },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
    format_on_save = { timeout_ms = 500 },
  },
  keys = {
    {
      '<leader>F',
      function()
        require('conform').format { async = true }
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
}
