local lsp = vim.lsp

local eslint_config_files = {
  '.eslintrc', '.eslintrc.js', '.eslintrc.cjs',
  '.eslintrc.yaml', '.eslintrc.yml', '.eslintrc.json',
  'eslint.config.js', 'eslint.config.mjs', 'eslint.config.cjs',
  'eslint.config.ts', 'eslint.config.mts', 'eslint.config.cts',
}

---@type vim.lsp.Config
return {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = {
    'javascript', 'javascriptreact', 'javascript.jsx',
    'typescript', 'typescriptreact', 'typescript.tsx',
    'vue', 'svelte', 'astro', 'htmlangular',
  },
  workspace_required = true,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(0, 'LspEslintFixAll', function()
      client:request_sync('workspace/executeCommand', {
        command = 'eslint.applyAllFixes',
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
            version = lsp.util.buf_versions[bufnr],
          },
        },
      }, nil, bufnr)
    end, {})
  end,
  root_dir = function(bufnr, on_dir)
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    root_markers = { root_markers } -- equal priority (0.11.3+)
    local project_root = vim.fs.root(bufnr, root_markers)
    if not project_root then return end

    local filename = vim.api.nvim_buf_get_name(bufnr)
    local is_buffer_using_eslint = vim.fs.find(eslint_config_files, {
      path = filename,
      type = 'file',
      limit = 1,
      upward = true,
      stop = vim.fs.dirname(project_root),
    })[1]
    if not is_buffer_using_eslint then return end

    on_dir(project_root)
  end,
  settings = {
    validate = 'on',
    packageManager = nil,
    useESLintClass = false,
    experimental = { useFlatConfig = false },
    codeActionOnSave = { enable = false, mode = 'all' },
    format = true,
    quiet = false,
    onIgnoredFiles = 'off',
    rulesCustomizations = {},
    run = 'onType',
    problems = { shortenToSingleLine = false },
    nodePath = '',
    workingDirectory = { mode = 'auto' },
    codeAction = {
      disableRuleComment = { enable = true, location = 'separateLine' },
      showDocumentation = { enable = true },
    },
  },
  before_init = function(_, config)
    local root_dir = config.root_dir
    if root_dir then
      config.settings = config.settings or {}
      config.settings.workspaceFolder = {
        uri = root_dir,
        name = vim.fn.fnamemodify(root_dir, ':t'),
      }

      -- Support flat config
      local flat_config_files = vim.tbl_filter(function(f) return f:match('config') end, eslint_config_files)
      for _, file in ipairs(flat_config_files) do
        local found = vim.fn.globpath(root_dir, file, true, true)
        local filtered = vim.tbl_filter(function(f)
          return not f:match('[/\\]node_modules[/\\]')
        end, found)
        if #filtered > 0 then
          config.settings.experimental = config.settings.experimental or {}
          config.settings.experimental.useFlatConfig = true
          break
        end
      end

      -- Support Yarn2 PnP
      if vim.uv.fs_stat(root_dir .. '/.pnp.cjs') or vim.uv.fs_stat(root_dir .. '/.pnp.js') then
        config.cmd = vim.list_extend({ 'yarn', 'exec' }, config.cmd)
      end
    end
  end,
  handlers = {
    ['eslint/openDoc'] = function(_, result)
      if result then vim.ui.open(result.url) end
      return {}
    end,
    ['eslint/confirmESLintExecution'] = function(_, result)
      if not result then return end
      return 4
    end,
    ['eslint/probeFailed'] = function()
      vim.notify('[eslint] probe failed.', vim.log.levels.WARN)
      return {}
    end,
    ['eslint/noLibrary'] = function()
      vim.notify('[eslint] Unable to find ESLint library.', vim.log.levels.WARN)
      return {}
    end,
  },
}
