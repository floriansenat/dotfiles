return {
	'folke/which-key.nvim',
	event = "VeryLazy",
	config = function()
		local wk = require 'which-key'

		wk.setup {
			icons = { mappings = false },
			plugins = {
				presets = { operators = false, motions = false }
			}
		}

		wk.add { { '<leader>b', group = '[B]uffer' } }
		wk.add { { '<leader>d', group = '[D]iff' } }
		wk.add { { '<leader>f', group = '[F]ile' } }
		wk.add { { '<leader>l', group = '[L]sp' } }
		wk.add { { '<leader>q', group = '[Q]uickfix' } }
		wk.add { { '<leader>s', group = '[S]earch' } }
	end
}
