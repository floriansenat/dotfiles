local wezterm = require 'wezterm'
local color_scheme = require 'color_scheme'
local projects = require 'projects'

local act = wezterm.action
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

config.leader = { key = ' ', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- Panes management
  { key = 'j', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'l', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'h', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },
  -- Workspaces management
  { key = 'p', mods = 'LEADER', action = projects.choose() },
  { key = 's', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
  { key = '[', mods = 'CTRL|SHIFT', action = act.SwitchWorkspaceRelative(1) },
  { key = ']', mods = 'CTRL|SHIFT', action = act.SwitchWorkspaceRelative(-1) },
  {
    key = 'w',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(act.SwitchToWorkspace { name = line }, pane)
        end
      end),
    },
  },
}

return config
