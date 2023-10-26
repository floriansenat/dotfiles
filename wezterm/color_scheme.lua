local wezterm = require 'wezterm'

local function scheme_for_appearance(appearance)
	if appearance:find 'Dark' then
		return 'Everforest Dark (Gogh)'
	else
		return 'Everforest Light (Gogh)'
	end
end

return scheme_for_appearance(wezterm.gui.get_appearance())
