return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = { adapter = 'anthropic' },
        inline = { adapter = 'anthropic' },
      },
      adapters = {
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            env = {
              api_key = 'ANTHROPIC_API_KEY',
            },
            schema = {
              model = {
                default = 'claude-3-5-sonnet-20241022',
              },
            },
          })
        end,
      },
    }
  end,
  keys = {
    { '<leader>a', ':CodeCompanionChat Toggle<CR>', mode = { 'n', 'v' } },
    { 'ga', ':CodeCompanionActions<CR>', mode = { 'n', 'v' } },
  },
}
