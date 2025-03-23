return {
  {
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
      },
    },
    init = function()
      require('plugins.codecompanion.spinner'):init()
    end,
    keys = {
      { '<leader>aa', '<cmd>CodeCompanionChat Toggle<cr>', desc = '[T]oggle', mode = { 'n', 'v' } },
      { 'ga', '<cmd>CodeCompanionActions<cr>', desc = 'Ai [A]ctions', mode = { 'n', 'v' } },
    },
  },
  -- {
  --   'huggingface/llm.nvim',
  --   opts = {
  --     backend = 'ollama',
  --     model = 'gemma3:4b',
  --     url = 'http://localhost:11434',
  --     request_body = {
  --       -- Modelfile options for the model you use
  --       options = {
  --         temperature = 0.2,
  --         top_p = 0.95,
  --       },
  --     },
  --     lsp = {
  --       bin_path = vim.api.nvim_call_function('stdpath', { 'data' }) .. '/mason/bin/llm-ls',
  --     },
  --   },
  -- },
}
