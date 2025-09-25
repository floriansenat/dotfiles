return {
  --:: LSP ::--
  { 'mason-org/mason.nvim', opts = {} },
  { 'j-hui/fidget.nvim', opts = {} },

  --:: Treesitter ::--
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
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
        highlight = { enable = true },
        indent = { enable = true },
      }
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
      { '<leader>c', '<cmd>NoNeckPain<CR>', desc = '[C]enter mode' },
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
      formatters_by_ft = {
        lua = { 'stylua' },
        typescript = { 'biome', lsp_format = 'never' },
        json = { 'biome', lsp_format = 'never' },
      },
      default_format_opts = {
        lsp_format = 'fallback',
      },
      format_on_save = function()
        if vim.g.disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
    },
    keys = {
      {
        '<leader>bf',
        function()
          require('conform').format { async = true }
        end,
        mode = '',
        desc = '[F]ormat',
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
      { '<leader>bh', ':UndotreeToggle<CR>', desc = '[H]istory' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { ']c', ':Gitsigns next_hunk<CR>', desc = 'Next [C]hange' },
      { '[c', ':Gitsigns prev_hunk<CR>', desc = 'Previous [C]hange' },
      { '<leader>gh', ':Gitsigns preview_hunk_inline<CR>', desc = '[H]unk' },
      { '<leader>gb', ':Gitsigns blame<CR>', desc = '[B]lame' },
      { '<leader>gr', ':Gitsigns reset_hunk<CR>', desc = '[R]eset hunk' },
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
  {
    'nvim-mini/mini.hipatterns',
    version = '*',
    config = function()
      local hipatterns = require 'mini.hipatterns'
      hipatterns.setup {
        highlighters = {
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }
    end,
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
          layout_strategy = 'bottom_pane',
          path_display = { 'truncate' },
          mappings = {
            n = {
              ['d'] = require('telescope.actions').delete_buffer,
              ['q'] = require('telescope.actions').close,
            },
          },
        },
        pickers = {
          buffers = { layout_strategy = 'center' },
          oldfiles = { layout_strategy = 'center' },
          help_tags = { layout_strategy = 'center' },
          find_files = {
            layout_strategy = 'center',
            hidden = true,
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
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_cursor {
              prompt_title = false,
              layout_config = { width = 0.25 },
            },
          },
        },
      }
      telescope.load_extension 'fzf'
      telescope.load_extension 'ui-select'
    end,
    keys = {
      { '<leader>/', ':Telescope find_files<CR>', desc = 'Search Files' },
      { '<leader>.', ':Telescope resume<CR>', desc = 'Search Resume' },
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

      wk.add { { '<leader>b', group = '[B]uffer' } }
      wk.add { { '<leader>d', group = '[D]iagnostics' } }
      wk.add { { '<leader>l', group = '[L]sp' } }
      wk.add { { '<leader>g', group = '[G]it' } }
    end,
  },
}
