local wezterm = require 'wezterm'
local color_scheme = require 'color_scheme'

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Colors & Appearance
config.color_scheme = color_scheme
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = 'RESIZE'
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.window_padding = {
	top = 0,
	bottom = 0
}


-- Fonts
config.font =
    wezterm.font('Dank Mono', { weight = 'Medium' })
config.font_size = 14.0
config.line_height = 1.4

return config
