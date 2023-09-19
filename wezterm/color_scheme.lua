local wezterm = require 'wezterm'

local function scheme_for_appearance(appearance)
	if appearance:find 'Dark' then
		return 'Rosé Pine (Gogh)'
	else
		return 'Rosé Pine Dawn (Gogh)'
	end
end

return scheme_for_appearance(wezterm.gui.get_appearance())
