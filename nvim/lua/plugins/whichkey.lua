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

		wk.add { { '<leader>g', group = '[G]it' } }
		wk.add { { '<leader>d', group = '[D]iff' } }
		wk.add { { '<leader>u', group = '[U]ndotree' } }
		wk.add { { '<leader>s', group = '[S]earch' } }
		wk.add { { '<leader>f', group = '[F]ile' } }
		wk.add { { '<leader>l', group = '[L]sp' } }
	end
}
