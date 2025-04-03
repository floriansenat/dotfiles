return {
  'chentoast/marks.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  opts = {},
  keys = {
    { '<leader>mb', ':MarksListBuf<CR>:lcl<CR>:Telescope loclist<CR>', desc = '[B]uffer' },
    { '<leader>ma', ':MarksListAll<CR>:lcl<CR>:Telescope loclist<CR>', desc = '[A]ll' },
  },
}
