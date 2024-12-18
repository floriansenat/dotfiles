local wezterm = require 'wezterm'

local function scheme_for_appearance()
  local appearance = wezterm.gui.get_appearance()

  if appearance:find 'Dark' then
    return 'Catppuccin Mocha'
  else
    return 'Catppuccin Latte'
  end
end

return scheme_for_appearance()
