return {
  {
    'savq/melange-nvim',
    config = function()
      vim.cmd.colorscheme 'melange'
    end,
  },
  {
    'f-person/auto-dark-mode.nvim',
    opts = { update_interval = 1000 },
  },
}
