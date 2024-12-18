return {
  'mbbill/undotree',
  lazy = true,
  init = function()
    vim.g.undotree_WindowLayout = 2
  end,
  keys = {
    { '<leader>du', ':UndotreeToggle<CR>', desc = '[U]ndotree' },
  },
}
