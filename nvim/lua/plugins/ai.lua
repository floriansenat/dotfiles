return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'j-hui/fidget.nvim',
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'codecompanion' },
      },
      ft = { 'markdown', 'codecompanion' },
    },
  },
  opts = {
    strategies = {
      chat = { adapter = 'ollama', roles = {
        user = 'fsenat',
      } },
      inline = { adapter = 'ollama' },
    },
    opts = { stream = true },
    display = {
      chat = {
        window = {
          position = 'right',
          width = 0.4,
        },
      },
      diff = {
        enabled = true,
        close_chat_at = 240,
        layout = 'vertical',
        opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'followwrap', 'linematch:120' },
        provider = 'default', -- default|mini_diff
      },
    },
  },
  init = function()
    require('plugins.fidget'):init()
  end,
  keys = {
    { '<leader>at', '<cmd>CodeCompanionChat Toggle<cr>', desc = '[T]oggle', mode = { 'n', 'v' } },
    { '<leader>aa', '<cmd>CodeCompanionChat Add<cr>', desc = '[A]dd', mode = { 'n', 'v' } },
    { 'ga', '<cmd>CodeCompanionActions<cr>', desc = 'Ai [A]ctions', mode = { 'n', 'v' } },
  },
}
