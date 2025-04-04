return {
  {
    'supermaven-inc/supermaven-nvim',
    opts = {
      condition = function()
        local current_dir = vim.fn.getcwd()
        local target_dir = 'work'
        return string.find(current_dir, target_dir)
      end,
    },
  },
  -- {
  --   'yetone/avante.nvim',
  --   event = 'VeryLazy',
  --   version = false,
  --   build = 'make',
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'stevearc/dressing.nvim',
  --     'nvim-lua/plenary.nvim',
  --     'MunifTanjim/nui.nvim',
  --   },
  --   opts = {},
  -- },
}
