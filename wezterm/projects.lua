local wezterm = require 'wezterm'

local module = {}
local home = wezterm.home_dir

local function get_projects()
  local projects = { home .. '/dotfiles', home .. '/notes', home .. '/Downloads' }

  for _, dir in ipairs(wezterm.glob(home .. '/work/*')) do
    table.insert(projects, dir)
  end

  for _, dir in ipairs(wezterm.glob(home .. '/personal/*')) do
    table.insert(projects, dir)
  end

  return projects
end

function module.choose()
  local choices = {}
  for _, value in ipairs(get_projects()) do
    table.insert(choices, { label = value })
  end

  return wezterm.action.InputSelector {
    title = 'Projects',
    choices = choices,
    fuzzy = true,
    action = wezterm.action_callback(function(child_window, child_pane, id, label)
      if not label then
        return
      end

      child_window:perform_action(
        wezterm.action.SwitchToWorkspace {
          name = label:match '([^/]+)$',
          spawn = { cwd = label },
        },
        child_pane
      )
    end),
  }
end

return module
