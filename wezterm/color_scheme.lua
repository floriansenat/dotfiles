local wezterm = require 'wezterm'

local function scheme_for_appearance(appearance)
	if appearance:find 'Dark' then
		return 'OneDark (base16)'
	else
		return 'One Light (base16)'
	end
end

return scheme_for_appearance(wezterm.gui.get_appearance())
