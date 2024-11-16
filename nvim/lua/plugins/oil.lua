local detail = false
return {
  'stevearc/oil.nvim',
  lazy = false,
  opts = {
    default_file_explorer = true,
    view_options = { show_hidden = true },
    keymaps = {
      ['gd'] = {
        desc = 'Toggle file detail view',
        callback = function()
          detail = not detail
          if detail then
            require('oil').set_columns { 'permissions', 'size', 'mtime' }
          else
            require('oil').set_columns {}
          end
        end,
      },
    },
  },
  keys = {
    { '-', ':Oil<CR>', desc = 'Open parent directory' },
  },
}
