local adapter = 'openai'

local function codestral_adapter()
  return require('codecompanion.adapters').extend('openai_compatible', {
    name = 'codestral',
    env = {
      api_key = 'CODESTRAL_API_KEY',
      url = 'https://codestral.mistral.ai',
      char_url = '/v1/chat/completions',
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

local function anthropic_adapter()
  return require('codecompanion.adapters').extend(adapter, {
    env = { api_key = 'ANTHROPIC_API_KEY' },
    schema = {
      model = { default = 'claude-3-5-sonnet-20241022' },
    },
  })
end

local ADAPTERS = {
  codestral = codestral_adapter,
  anthropic = anthropic_adapter,
}

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = { adapter = adapter },
        inline = { adapter = adapter },
      },
      opts = { stream = true },
      adapters = ADAPTERS[adapter],
    }
  end,
  keys = {
    { '<leader>a', ':CodeCompanionChat Toggle<CR>', mode = { 'n', 'v' } },
    { 'ga', ':CodeCompanionActions<CR>', mode = { 'n', 'v' } },
  },
}
