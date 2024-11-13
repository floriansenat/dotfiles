return {
	'sindrets/diffview.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local diffview = require('diffview')
		diffview.setup {
			use_icons = false,
			view = { merge_tool = { layout = 'diff3_mixed' } }
		}
		vim.keymap.set('n', '<leader>do', diffview.open, { desc = "[O]pen" })
		vim.keymap.set('n', '<leader>dc', diffview.close, { desc = "[C]lose" })
		vim.keymap.set('n', '<leader>df', diffview.file_history, { desc = "[F]ile" })
		vim.keymap.set('n', '<leader>fh', diffview.file_history, { desc = "[H]istory" })
	end
}
