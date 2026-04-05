---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'biome'
    local mason_cmd = vim.fn.stdpath 'data' .. '/mason/bin/biome'
    if mason_cmd and vim.fn.executable(mason_cmd) == 1 then
      cmd = mason_cmd
    end
    return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)
  end,
  filetypes = {
    'astro', 'css', 'graphql', 'html',
    'javascript', 'javascriptreact', 'json', 'jsonc',
    'svelte', 'typescript', 'typescript.tsx', 'typescriptreact', 'vue',
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    root_markers = { root_markers } -- equal priority (0.11.3+)
    local project_root = vim.fs.root(bufnr, root_markers)
    if not project_root then return end

    local filename = vim.api.nvim_buf_get_name(bufnr)
    local is_buffer_using_biome = vim.fs.find({ 'biome.json', 'biome.jsonc' }, {
      path = filename,
      type = 'file',
      limit = 1,
      upward = true,
      stop = vim.fs.dirname(project_root),
    })[1]
    if not is_buffer_using_biome then return end

    on_dir(project_root)
  end,
}
