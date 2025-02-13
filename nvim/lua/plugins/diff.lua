return {
  'sindrets/diffview.nvim',
  lazy = true,
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    use_icons = false,
    view = { merge_tool = { layout = 'diff3_mixed' } },
  },
  keys = {
    { '<leader>do', ':DiffviewOpen<CR>', desc = '[O]pen' },
    { '<leader>dc', ':DiffviewClose<CR>', desc = '[C]lose' },
    { '<leader>fh', ':DiffviewFileHistory %<CR>', desc = '[H]istory' },
  },
}
