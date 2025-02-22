return {
  -- { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  { 'neanias/everforest-nvim', name = 'everforest', priority = 1000, lazy = false },
  {
    'f-person/auto-dark-mode.nvim',
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option('background', 'dark')
        vim.cmd 'colorscheme everforest'
      end,
      set_light_mode = function()
        vim.api.nvim_set_option('background', 'light')
        vim.cmd 'colorscheme everforest'
      end,
    },
  },
}
