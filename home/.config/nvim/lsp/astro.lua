---@type vim.lsp.Config
return {
  cmd = { 'astro-ls', '--stdio' },
  filetypes = { 'astro' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
  init_options = {
    typescript = {},
  },
  before_init = function(_, config)
    if config.init_options and config.init_options.typescript and not config.init_options.typescript.tsdk then
      -- Cherche typescript dans node_modules du projet
      local root = config.root_dir or ''
      local candidates = {
        root .. '/node_modules/typescript/lib',
        root .. '/node_modules/typescript/lib/typescript.js',
      }
      for _, path in ipairs(candidates) do
        if vim.uv.fs_stat(path) then
          config.init_options.typescript.tsdk = root .. '/node_modules/typescript/lib'
          break
        end
      end
    end
  end,
}
