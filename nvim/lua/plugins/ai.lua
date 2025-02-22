local function lm_studio_adapter()
  return require('codecompanion.adapters').extend('openai_compatible', {
    name = 'lm_studio',
    env = {
      url = 'http://localhost:1234',
    },
    schema = {
      model = { default = 'deepseek-r1-distill-qwen-7b' },
    },
  })
end

local function codestral_adapter()
  return require('codecompanion.adapters').extend('openai_compatible', {
    name = 'codestral',
    env = {
      api_key = 'CODESTRAL_API_KEY',
      url = 'https://codestral.mistral.ai',
    },
    handlers = {
      form_parameters = function(_, params, _)
        -- codestral doesn't support these in the body
        params.stream_options = nil
        params.options = nil

        return params
      end,
    },
    schema = {
      model = { default = 'codestral-latest' },
      temperature = {
        default = 0.2,
        mapping = 'parameters', -- not supported in default parameters.options
      },
    },
  })
end

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = { adapter = 'openai' },
        inline = { adapter = 'openai' },
      },
      opts = { stream = true },
      adapters = {
        anthropic = 'anthropic',
        openai = codestral_adapter(),
      },
    }
  end,
  keys = {
    { '<leader>a', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' } },
    { 'ga', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' } },
  },
}
