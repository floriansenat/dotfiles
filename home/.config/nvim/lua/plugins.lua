return {
  --:: LSP ::--
  { 'mason-org/mason.nvim', opts = {} },
  { 'j-hui/fidget.nvim', opts = {} },

  --:: Treesitter ::--
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
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
      },
      auto_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  --:: Text Manipulation ::--
  { 'nvim-mini/mini.pairs', version = '*', opts = {} },
  { 'kylechui/nvim-surround', event = 'InsertEnter', opts = {} },
  {
    'shortcuts/no-neck-pain.nvim',
    version = '*',
    opts = { width = 120 },
    keys = {
      { '<leader>c', '<cmd>NoNeckPain<CR>', desc = 'Center mode' },
    },
  },
  {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    opts = {
      keys = {
        {
          '>',
          ":lua require'quicker'.expand { before = 2, after = 2, add_to_existing = true } <CR>",
          desc = 'Expand quickfix context',
        },
        {
          '<',
          ":lua require'quicker'.collapse()<CR>",
          desc = 'Collapse quickfix context',
        },
      },
    },
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        lua = { 'stylua' },
        json = { 'biome' },
        jsonc = { 'biome' },
        javascript = { 'biome', 'biome-organize-imports' },
        javascriptreact = { 'biome', 'biome-organize-imports' },
        typescript = { 'biome', 'biome-organize-imports' },
        typescriptreact = { 'biome', 'biome-organize-imports' },
        go = { 'goimports', 'gofmt' },
        rust = { 'rustfmt' },
        php = { 'php_cs_fixer' },
      },
      default_format_opts = {
        lsp_format = 'fallback',
      },
      format_on_save = function()
        if vim.g.disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = 'never' }
      end,
    },
    keys = {
      {
        '<leader>bf',
        function()
          require('conform').format { async = true, lsp_format = 'never' }
        end,
        mode = '',
        desc = 'Format',
      },
    },
  },
  {
    'saghen/blink.cmp',
    dependencies = { 'neovim/nvim-lspconfig' },
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
        default = { 'lsp', 'path', 'buffer' },
      },
      signature = { enabled = true },
    },
    opts_extend = { 'sources.default' },
  },

  --:: History ::--
  {
    'mbbill/undotree',
    lazy = true,
    init = function()
      vim.g.undotree_WindowLayout = 2
    end,
    keys = {
      { '<leader>bh', ':UndotreeToggle<CR>', desc = 'History' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { ']c', ':Gitsigns next_hunk<CR>', desc = 'Next Change' },
      { '[c', ':Gitsigns prev_hunk<CR>', desc = 'Previous Change' },
      { '<leader>hs', ':Gitsigns preview_hunk_inline<CR>', desc = 'Show' },
      { '<leader>hr', ':Gitsigns reset_hunk<CR>', desc = 'Reset' },
      { '<leader>bb', ':Gitsigns blame<CR>', desc = 'Blame' },
    },
  },

  --:: Theme ::--
  {
    'savq/melange-nvim',
    config = function()
      vim.cmd.colorscheme 'melange'
    end,
  },
  {
    'f-person/auto-dark-mode.nvim',
    opts = { update_interval = 1000 },
  },

  --:: Navigation ::--
  {
    'stevearc/oil.nvim',
    dependencies = { { 'nvim-tree/nvim-web-devicons', opts = {} } },
    lazy = false,
    opts = {
      default_file_explorer = true,
      view_options = { show_hidden = true },
    },
    keys = {
      { '-', ':Oil<CR>', desc = 'Open parent directory' },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
      { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    config = function()
      local telescope = require 'telescope'

      telescope.setup {
        defaults = {
          sorting_strategy = 'ascending',
          path_display = { 'smart' },
          borderchars = { '', '', '', '', '', '', '', '' },
          layout_config = {
            height = 100,
            width = 400,
            prompt_position = 'top',
            preview_cutoff = 40,
          },
          mappings = {
            n = {
              ['d'] = require('telescope.actions').delete_buffer,
              ['q'] = require('telescope.actions').close,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            results_title = false,
            preview_title = false,
            find_command = {
              'rg',
              '--files',
              '--hidden',
              '--glob=!**/.git/*',
              '--glob=!**/.idea/*',
              '--glob=!**/.vscode/*',
              '--glob=!**/build/*',
              '--glob=!**/dist/*',
              '--glob=!**/yarn.lock',
              '--glob=!**/package-lock.json',
            },
          },
          live_grep = {
            results_title = false,
            preview_title = false,
          },
          buffers = {
            results_title = false,
            preview_title = false,
          },
          oldfiles = {
            results_title = false,
            preview_title = false,
          },
          help_tags = {
            results_title = false,
            preview_title = false,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_cursor {
              prompt_title = false,
              layout_config = { width = 0.25 },
              borderchars = {
                '─',
                '│',
                '─',
                '│',
                '┌',
                '┐',
                '┘',
                '└',
              },
            },
          },
        },
      }
      telescope.load_extension 'fzf'
      telescope.load_extension 'ui-select'
    end,
    keys = {
      { '<leader>sf', ':Telescope find_files<CR>', desc = 'Search Files' },
      { '<leader><leader>', ':Telescope buffers<CR>', desc = 'Buffers' },
      { '<leader>?', ':Telescope help_tags<CR>', desc = 'Search Help' },
      { '<leader>;', ':Telescope oldfiles<CR>', desc = 'Oldfiles' },
    },
  },

  --:: Whichkey ::--
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      local wk = require 'which-key'

      wk.setup {
        preset = 'helix',
        icons = { mappings = false },
        plugins = {
          presets = { operators = false, motions = false },
        },
      }

      wk.add { { '<leader>b', group = 'Buffer' } }
      wk.add { { '<leader>d', group = 'Diagnostics' } }
      wk.add { { '<leader>l', group = 'Lsp' } }
      wk.add { { '<leader>h', group = 'Hunk' } }
      wk.add { { '<leader>s', group = 'Search' } }
    end,
  },
}
