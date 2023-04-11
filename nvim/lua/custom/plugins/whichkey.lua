return {
	{
		'folke/which-key.nvim',
		config = function()
			local wk = require('which-key')

			vim.o.timeout = true
			vim.o.timeoutlen = 300

			wk.setup({
				plugins = {
					presets = {
						operators = false,
						motions = false
					}
				}
			})

			wk.register({ ['<leader>s'] = { name = '[S]earch' } })
		end
	}
}
