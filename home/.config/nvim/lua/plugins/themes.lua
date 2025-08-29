return {
  {
    'lunacookies/vim-colors-xcode',
    config = function()
      vim.cmd.colorscheme 'xcodehc'
    end,
  },
  {
    'f-person/auto-dark-mode.nvim',
    opts = { update_interval = 1000 },
  },
}
