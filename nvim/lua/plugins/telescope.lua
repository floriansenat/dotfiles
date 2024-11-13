return {
	'nvim-telescope/telescope.nvim',
	lazy = true,
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		'nvim-telescope/telescope-ui-select.nvim'
	},
	config = function()
		local telescope = require 'telescope'
		telescope.setup {
			extensions = {
				["ui-select"] = {
					require 'telescope.themes'.get_cursor({
						prompt_title = false,
						layout_config = { width = 0.25 },
					})
				}
			}
		}
		telescope.load_extension 'fzf'
		telescope.load_extension 'ui-select'
	end,
	keys = {
		{ '<leader>sf',       ':Telescope find_files<CR>',  { desc = '[F]iles' } },
		{ '<leader>sW',       ':Telescope live_grep<CR>',   { desc = '[W]ord' } },
		{ '<leader>sw',       ':Telescope grep_string<CR>', { desc = '[W]ord under cursor' } },
		{ '<leader>sr',       ':Telescope resume<CR>',      { desc = '[R]esume' } },
		{ '<leader><leader>', ':Telescope buffers<CR>',     { desc = 'Buffers' } },
		{ '<leader>?',        ':Telescope oldfiles<CR>',    { desc = 'Oldfiles' } },
	}
}
