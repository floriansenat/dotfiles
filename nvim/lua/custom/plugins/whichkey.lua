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
			wk.register({ ['<leader>g'] = { name = '[G]it' } })
			wk.register({ ['<leader>p'] = { name = '[P]roject' } })
			wk.register({ ["<leader>d"] = { name = "[D]iagnostic" } })
			wk.register({ ['<leader>S'] = { name = '[S]ymbols' } })
			wk.register({ ['<leader>c'] = { name = '[C]ode' } })
		end
	}
}
