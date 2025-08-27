return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      typescript = { 'biome', lsp_format = 'never' },
      json = { 'biome', lsp_format = 'never' },
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
