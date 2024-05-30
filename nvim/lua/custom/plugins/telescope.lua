local function filename_first(_, path)
	local tail = vim.fs.basename(path)
	local parent = vim.fs.dirname(path)
	if parent == "." then return tail end
	return string.format("%s\t-\t%s", tail, parent)
end

return {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local telescope = require('telescope')
			local builtin = require('telescope.builtin')
			local themes = require('telescope.themes')

			local file_picker = {
				path_display = filename_first,
				theme = 'dropdown',
				layout_config = {
					anchor = 'N',
					width = 0.3,
					height = 0.3,
				},
				previewer = false,
				prompt_title = false,
			}

			telescope.setup({
				defaults = themes.get_dropdown({
					path_display = { "tail" },
					layout_config = { width = 0.5 },
					prompt_prefix = '',
					prompt_title = false,
				}),
				pickers = {
					find_files = file_picker,
					oldfiles = file_picker,
					buffers = file_picker,
				},
				extensions = {
					["ui-select"] = {
						themes.get_cursor({
							prompt_title = false,
							layout_config = { width = 0.25 },
						})
					}
				}
			})
			telescope.load_extension('fzf')
			telescope.load_extension('ui-select')

			vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = "[F]iles" })
			vim.keymap.set('n', '<leader>sW', builtin.live_grep, { desc = "[W]ord" })
			vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = "[W]ord under cursor" })
			vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = "[R]esume" })
			vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = "Show buffers" })
			vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = "Oldfiles" })
			vim.keymap.set('n', 'gw', builtin.grep_string, { desc = "Grep cursor [W]ord" })
		end
	},
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	{ 'nvim-telescope/telescope-ui-select.nvim' }
}
