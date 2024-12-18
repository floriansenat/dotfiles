return {
  'lewis6991/gitsigns.nvim',
  event = 'VeryLazy',
  opts = {},
  keys = {
    { ']c', ':Gitsigns next_hunk<CR>', desc = 'Next [C]hange' },
    { '[c', ':Gitsigns prev_hunk<CR>', desc = 'Previous [C]hange' },
    { '<leader>gh', ':Gitsigns preview_hunk_inline<CR>', desc = '[H]unk' },
    { '<leader>gb', ':Gitsigns blame<CR>', desc = '[B]lame' },
    { '<leader>gr', ':Gitsigns reset_hunk<CR>', desc = '[R]eset hunk' },
  },
}
