local state = {
  show_path = true,
  show_branch = true,
}

local config = {
  icons = {
    path_hidden = '',
    branch_hidden = '',
  },
  placeholder_hl = 'StatusLineDim',
}

local function hl(group, text)
  return string.format('%%#%s#%s%%*', group, text)
end

vim.api.nvim_set_hl(0, config.placeholder_hl, { link = 'Comment' })

-- jj bookmark detection
local function refresh_jj_bookmark()
  local result = vim
    .system({ 'jj', 'log', '-r', 'heads(::@ & bookmarks())', '--no-graph', '-T', 'bookmarks', '--limit', '1' }, { text = true, cwd = vim.fn.getcwd() })
    :wait()
  if result.code == 0 and result.stdout ~= '' then
    vim.g._jj_bookmark = vim.trim(result.stdout)
    return
  end
  local result2 = vim.system({ 'jj', 'log', '-r@', '--no-graph', '-T', 'change_id.shortest()' }, { text = true, cwd = vim.fn.getcwd() }):wait()
  if result2.code == 0 and result2.stdout ~= '' then
    vim.g._jj_bookmark = vim.trim(result2.stdout)
    return
  end
  vim.g._jj_bookmark = nil
end

local function filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.:h')
  if fpath == '' or fpath == '.' then
    return ''
  end
  if state.show_path then
    return string.format('%%<%s/', fpath)
  end
  return hl(config.placeholder_hl, config.icons.path_hidden .. '/')
end

local function branch()
  local name = vim.g._jj_bookmark
  if not name then
    local git_info = vim.b.gitsigns_status_dict
    if git_info and git_info.head ~= '' then
      name = git_info.head
    end
  end
  if not name then
    return ''
  end
  if not state.show_branch then
    return hl(config.placeholder_hl, config.icons.branch_hidden)
  end
  return name
end

local function diagnostics()
  local counts = vim.diagnostic.count(0)
  local parts = {}
  local errs = counts[vim.diagnostic.severity.ERROR] or 0
  local warns = counts[vim.diagnostic.severity.WARN] or 0
  if errs > 0 then
    table.insert(parts, hl('DiagnosticError', 'E:' .. errs))
  end
  if warns > 0 then
    table.insert(parts, hl('DiagnosticWarn', 'W:' .. warns))
  end
  if #parts == 0 then
    return ''
  end
  return table.concat(parts, ' ') .. ' '
end

Statusline = {}

function Statusline.active()
  return table.concat {
    ' ',
    filepath(),
    '%t',
    ' | ',
    branch(),
    '%=',
    diagnostics(),
    '| %y | %P %l:%c ',
  }
end

function Statusline.inactive()
  return ' %t'
end

function Statusline.toggle_path()
  state.show_path = not state.show_path
  vim.cmd 'redrawstatus'
end

function Statusline.toggle_branch()
  state.show_branch = not state.show_branch
  vim.cmd 'redrawstatus'
end

vim.keymap.set('n', '<leader>sp', Statusline.toggle_path, { desc = 'Toggle statusline path' })
vim.keymap.set('n', '<leader>sb', Statusline.toggle_branch, { desc = 'Toggle statusline branch' })

local group = vim.api.nvim_create_augroup('Statusline', { clear = true })

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = group,
  callback = function()
    vim.opt_local.statusline = '%!v:lua.Statusline.active()'
  end,
})

vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = group,
  callback = function()
    vim.opt_local.statusline = '%!v:lua.Statusline.inactive()'
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained' }, {
  group = group,
  callback = function()
    refresh_jj_bookmark()
  end,
})
