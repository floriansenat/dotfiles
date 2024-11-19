local wezterm = require 'wezterm'

local module = {}

local function get_projects()
  local projects = { wezterm.home_dir .. '/dotfiles', wezterm.home_dir .. '/notes' }

  for _, dir in ipairs(wezterm.glob(wezterm.home_dir .. '/work/*')) do
    table.insert(projects, dir)
  end

  for _, dir in ipairs(wezterm.glob(wezterm.home_dir .. '/personal/*')) do
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
