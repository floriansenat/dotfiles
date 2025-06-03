return {
  'mistweaverco/kulala.nvim',
  keys = {
    { '<leader>hs', desc = '[S]end' },
    { '<leader>ha', desc = 'Send [A]ll requests' },
    { '<leader>hd', desc = '[D]raft' },
  },
  ft = { 'http', 'rest' },
  opts = {
    global_keymaps = true,
    global_keymaps_prefix = '<leader>h',
    kulala_keymaps_prefix = '',
  },
}
