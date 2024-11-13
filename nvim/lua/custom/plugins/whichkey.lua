return {
	'folke/which-key.nvim',
	config = function()
		local wk = require 'which-key'

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

		wk.register({ ['<leader>d'] = { name = '[D]iff' } })
		wk.register({ ['<leader>u'] = { name = '[U]ndotree' } })
		wk.register({ ['<leader>s'] = { name = '[S]earch' } })
		wk.register({ ['<leader>f'] = { name = '[F]ile' } })
		wk.register({ ['<leader>l'] = { name = '[L]sp' } })
	end
}
