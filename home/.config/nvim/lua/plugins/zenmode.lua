return {
  'folke/zen-mode.nvim',
  lazy = true,
  opts = { window = { width = 0.6 } },
  keys = {
    { '<leader>z', '<cmd>ZenMode<CR>', desc = 'Toggle [Z]en mode' },
  },
}
