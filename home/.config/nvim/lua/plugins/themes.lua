return {
  { 'savq/melange-nvim', name = 'melange', priority = 1000 },
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000, opts = {
    transparent_background = true,
  } },
  {
    'f-person/auto-dark-mode.nvim',
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option('background', 'dark')
        vim.cmd 'colorscheme melange'
      end,
      set_light_mode = function()
        vim.api.nvim_set_option('background', 'light')
        vim.cmd 'colorscheme melange'
      end,
    },
  },
}
