return {
    { 'mason-org/mason.nvim', opts = {} },
    { 'j-hui/fidget.nvim',    opts = {} },
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
                'zig',
            },
            auto_install = true,
            highlight = { enable = true, additional_vim_regex_highlighting = false },
            indent = { enable = true },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end,
    },
    { 'nvim-mini/mini.pairs',   version = '*',         opts = {} },
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
            { ']c',         ':Gitsigns next_hunk<CR>',           desc = 'Next Change' },
            { '[c',         ':Gitsigns prev_hunk<CR>',           desc = 'Previous Change' },
            { '<leader>hs', ':Gitsigns preview_hunk_inline<CR>', desc = 'Show' },
            { '<leader>hr', ':Gitsigns reset_hunk<CR>',          desc = 'Reset' },
            { '<leader>bb', ':Gitsigns blame<CR>',               desc = 'Blame' },
        },
    },
    {
        'f-person/auto-dark-mode.nvim',
        dependencies = { { 'savq/melange-nvim' } },
        opts = {
            update_interval = 1000,
            set_dark_mode = function()
                vim.api.nvim_set_option_value('background', 'dark', {})
                vim.cmd.colorscheme 'melange'
            end,
            set_light_mode = function()
                vim.api.nvim_set_option_value('background', 'light', {})
                vim.cmd.colorscheme 'melange'
            end,
        },
    },
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
        'dmtrKovalenko/fff.nvim',
        build = function()
            require('fff.download').download_or_build_binary()
        end,
        opts = {
            prompt = '➜ ',
            title = 'Search',
            layout = {
                -- Use 0.99 instead of 1.0 because otherwise the first item in list is hidden by the prompt
                height = 0.99,
                width = 0.99,
            },
        },
        lazy = false,
        keys = {
            {
                '<leader>sf',
                function()
                    require('fff').find_files()
                end,
                desc = '[F]iles',
            },
            {
                '<leader>sg',
                function()
                    require('fff').live_grep()
                end,
                desc = '[G]rep',
            },
            {
                '<leader>ss',
                function()
                    require('fff').scan_files()
                end,
                desc = '[S]can',
            },
        },
    },
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
    {
        'b0o/incline.nvim',
        dependencies = { { 'nvim-tree/nvim-web-devicons', opts = {} } },
        event = 'VeryLazy',
        config = function()
            -- Create custom highlight groups for transparent background
            vim.api.nvim_set_hl(0, 'InclineNormalTransparent', {
                fg = vim.api.nvim_get_hl(0, { name = 'Comment' }).fg,
                bg = 'NONE',
            })

            require('incline').setup {
                hide = {
                    cursorline = true,
                },
                highlight = {
                    groups = {
                        InclineNormal = 'InclineNormalTransparent',
                        InclineNormalNC = 'InclineNormalTransparent',
                    },
                },
                window = {
                    padding = 1,
                    margin = { vertical = 0, horizontal = 1 },
                },
                render = function(props)
                    local devicons = require 'nvim-web-devicons'

                    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                    if filename == '' then
                        filename = '[No Name]'
                    end

                    local ft_icon = devicons.get_icon_color(filename)
                    return {
                        ft_icon and { ' ', ft_icon, ' ' } or '',
                        ' ',
                        { filename },
                        ' ',
                    }
                end,
            }
        end,
    },
}
