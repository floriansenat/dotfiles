local state = {
  show_path = true,
}

local config = {
  icons = {
    path_hidden = '',
  },
  placeholder_hl = 'StatusLineDim',
}

local function hl(group, text)
  return string.format('%%#%s#%s%%*', group, text)
end

vim.api.nvim_set_hl(0, config.placeholder_hl, { link = 'Comment' })

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
    if vim.api.nvim_win_get_config(0).relative ~= '' then
      return
    end
    vim.opt_local.statusline = '%!v:lua.Statusline.active()'
  end,
})

vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = group,
  callback = function()
    if vim.api.nvim_win_get_config(0).relative ~= '' then
      return
    end
    vim.opt_local.statusline = '%!v:lua.Statusline.inactive()'
  end,
})
