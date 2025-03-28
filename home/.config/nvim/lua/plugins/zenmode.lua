return {
  'folke/zen-mode.nvim',
  lazy = true,
  opts = { window = { width = 0.7 } },
  keys = {
    { '<leader>z', '<cmd>ZenMode<CR>', desc = 'Toggle [Z]en mode' },
  },
}
