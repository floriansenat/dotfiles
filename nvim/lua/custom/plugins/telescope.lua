return {
	{
		'nvim-telescope/telescope.nvim',
		version = '*',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local telescope = require('telescope')
			local builtin = require('telescope.builtin')
			local themes = require('telescope.themes')

			telescope.setup({
				defaults = {
					sorting_strategy = "ascending",
					layout_config = {
						height = 0.8,
						prompt_position = 'top',
						preview_width = 0.4,
					},
				},
			})

			pcall(telescope.load_extension, 'fzf')

			-- [[Search]]
			vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = 'Find recently opened files' })
			vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = 'Find existing buffers' })
			vim.keymap.set('n', '<leader>/', function()
				builtin.current_buffer_fuzzy_find(themes.get_dropdown { previewer = false })
			end, { desc = 'Fuzzily search in current buffer' })
			vim.keymap.set('n', '<C-p>', builtin.git_files, {})
			vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[F]iles' })
			vim.keymap.set('n', '<leader>s?', builtin.help_tags, { desc = 'Help' })
			vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Current [W]ord' })
			vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'With [G]rep' })
			vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[D]iagnostics' })
			vim.keymap.set('n', '<leader>se', function()
				builtin.find_files({ find_command = { 'rg', '--files', '-g', '.env*' } })
			end, { desc = 'Search [E]nvs' })

			-- [[LSP]]
			vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = '[G]oto [R]eferences' })
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[G]oto [D]efinition' })
			vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { desc = '[G]oto [I]mplementation' })
			vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })

			-- [[Symbols]]
			vim.keymap.set('n', '<leader>ssb', builtin.lsp_document_symbols, { desc = '[B]uffer' })
			vim.keymap.set('n', '<leader>ssw', builtin.lsp_dynamic_workspace_symbols,
				{ desc = '[W]orkspace' })
		end
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
	}
}
