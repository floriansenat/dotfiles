local file_picker = {
	theme = 'dropdown',
	layout_config = {
		anchor = 'N',
		width = 0.3,
		height = 0.3,
	},
	prompt_title = false,
	previewer = false,
}

return {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local telescope = require('telescope')
			local builtin = require('telescope.builtin')

			telescope.setup({
				defaults = {
					prompt_prefix = '',
					-- path_display = { truncate = 2 }
					path_display = {"smart"}
				},
				pickers = {
					find_files = file_picker,
					oldfiles = file_picker,
					lsp_document_symbols = {
						theme = 'dropdown',
						prompt_title = false,
						layout_config = {
							anchor = 'N',
							width = 0.5,
							height = 0.3,
						}
					}
				},
			})
			telescope.load_extension('fzf')
			telescope.load_extension('ui-select')

			vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = "[F]iles" })
			vim.keymap.set('n', '<leader>sw', builtin.live_grep, { desc = "[W]ord" })
			vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = "Show buffers" })
			vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = "Oldfiles" })
			vim.keymap.set('n', 'gw', builtin.grep_string, { desc = "Grep cursor [W]ord" })
		end
	},
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	{ 'nvim-telescope/telescope-ui-select.nvim' }
}
