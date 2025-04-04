local languages = {
  'lua',
  'php',
  'go',
  'tsx',
  'typescript',
  'javascript',
  'json',
  'html',
  'css',
  'vimdoc',
  'vim',
  'markdown',
  'markdown_inline',
  'astro',
}

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = languages,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
      },
    }
  end,
}
