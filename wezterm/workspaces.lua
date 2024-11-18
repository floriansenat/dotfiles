local wezterm = require 'wezterm'

local action = wezterm.action
local mux = wezterm.mux

local workspace_switcher = wezterm.plugin.require 'https://github.com/MLFlexer/smart_workspace_switcher.wezterm'
workspace_switcher.zoxide_path = '/opt/homebrew/bin/zoxide'

-- Set up workspace to be loaded on startup of wezterm
wezterm.on('gui-startup', function()
  local dotfiles_path = wezterm.home_dir .. '/.dotfiles'
  local _, build_pane, _ = mux.spawn_window {
    workspace = 'dotfiles',
    cwd = dotfiles_path,
  }
  build_pane:send_text 'nvim\n'
  mux.set_active_workspace 'dotfiles'
end)

return {
  { key = 'd', mods = 'CTRL|SHIFT', action = action.SwitchToWorkspace { name = 'dotfiles' } },
  { key = 's', mods = 'CTRL|SHIFT', action = workspace_switcher.switch_workspace() },
  { key = 't', mods = 'CTRL|SHIFT', action = action.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
  { key = '[', mods = 'CTRL|SHIFT', action = action.SwitchWorkspaceRelative(1) },
  { key = ']', mods = 'CTRL|SHIFT', action = action.SwitchWorkspaceRelative(-1) },
}
