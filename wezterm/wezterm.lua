local wezterm = require 'wezterm'
local color_scheme = require 'color_scheme'
local workspaces_keys = require 'workspaces'

local action = wezterm.action
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Colors & Appearance
config.color_scheme = color_scheme
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = 'RESIZE'
config.window_padding = {
  top = 30,
  bottom = 0,
}

-- Fonts
config.font = wezterm.font('Departure Mono', { weight = 'Medium' }) -- For fun only :D
-- config.font = wezterm.font('Dank Mono', { weight = 'Medium' })
config.font_size = 15.0
config.line_height = 1.4

config.keys = {
  -- Panes management
  { key = '"', mods = 'CTRL|SHIFT', action = action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = ':', mods = 'CTRL|SHIFT', action = action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'h', mods = 'CTRL|SHIFT', action = action.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'CTRL|SHIFT', action = action.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'CTRL|SHIFT', action = action.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'CTRL|SHIFT', action = action.ActivatePaneDirection 'Down' },
  -- Workspaces management
  table.unpack(workspaces_keys),
}

return config
