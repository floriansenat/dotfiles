return {
  'nvim-lualine/lualine.nvim',
  opts = {
    extensions = { 'oil', 'man' },
    options = {
      icons_enabled = false,
      section_separators = '',
      component_separators = '',
    },
    sections = {
      lualine_a = {},
      lualine_b = { 'diff', 'diagnostics' },
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = {},
      lualine_y = { 'filetype' },
      lualine_z = {},
    },
  },
}
