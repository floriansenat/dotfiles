vim.api.nvim_create_user_command('FormatToggle', function()
  if vim.g.disable_autoformat then
    vim.g.disable_autoformat = false
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Toggle autoformat-on-save',
})

vim.keymap.set('n', '<leader>Ft', ':FormatToggle<CR>', { desc = '[T]oggle' })
vim.keymap.set('n', '<leader>Ft', ':FormatToggle<CR>', { desc = '[T]oggle' })

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
    format_on_save = function()
      if vim.g.disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
  },
  keys = {
    {
      '<leader>Fb',
      function()
        require('conform').format { async = true }
      end,
      mode = '',
      desc = '[B]uffer',
    },
  },
}
