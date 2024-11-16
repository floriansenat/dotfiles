local modes = {
  ['NORMAL'] = 'N',
  ['O-PENDING'] = 'N?',
  ['INSERT'] = 'I',
  ['VISUAL'] = 'V',
  ['V-BLOCK'] = 'VB',
  ['V-LINE'] = 'VL',
  ['V-REPLACE'] = 'VR',
  ['REPLACE'] = 'R',
  ['COMMAND'] = 'C',
  ['SHELL'] = 'SH',
  ['TERMINAL'] = 'T',
  ['EX'] = 'X',
  ['SELECT'] = 'S',
  ['S-LINE'] = 'SL',
  ['S-BLOCK'] = 'SB',
  ['CONFIRM'] = 'Y?',
  ['MORE'] = 'M',
}

return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      icons_enabled = false,
      theme = 'auto',
      component_separators = '',
    },
    sections = {
      lualine_a = { {
        'mode',
        fmt = function(mode)
          return modes[mode] or mode
        end,
      } },
      lualine_b = { 'diff', 'diagnostics' },
      lualine_c = { '%=', { 'filename', path = 1 } },
      lualine_x = {},
      lualine_y = { 'filetype' },
      lualine_z = { 'branch' },
    },
  },
}
