return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'neovim/nvim-lspconfig',
    },
    version = '1.*',
    opts = {
      keymap = {
        preset = 'default',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        list = { selection = { preselect = true, auto_insert = true } },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        accept = { auto_brackets = { enabled = false } },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      signature = { enabled = true },
    },
    opts_extend = { 'sources.default' },
  },
}
