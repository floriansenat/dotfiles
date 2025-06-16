return {
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
    local builtin = require 'telescope.builtin'

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

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function()
        vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = '[D]efinition' })
        vim.keymap.set('n', 'gD', builtin.lsp_type_definitions, { desc = '[D]eclaration' })
        vim.keymap.set('n', 'gI', builtin.lsp_implementations, { desc = '[I]mplementation' })
        vim.keymap.set('n', 'gA', builtin.lsp_references, { desc = '[A]ll references' })
        vim.keymap.set('n', 'gs', builtin.lsp_document_symbols, { desc = 'Buffer [S]ymbols' })
      end,
    })
  end,
  keys = {
    { '<leader>sf', ':Telescope find_files<CR>', desc = '[F]iles' },
    { '<leader>sr', ':Telescope resume<CR>', desc = '[R]esume' },
    { '<leader><leader>', ':Telescope buffers<CR>', desc = 'Buffers' },
    { '<leader>?', ':Telescope help_tags<CR>', desc = 'Help' },
    { '<leader>;', ':Telescope oldfiles<CR>', desc = 'Oldfiles' },
  },
}
