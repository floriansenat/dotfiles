return {
	'lewis6991/gitsigns.nvim',
	event = "VeryLazy",
	opts = {
		on_attach = function()
			local gitsigns = require 'gitsigns'

			vim.keymap.set('n', ']c', function()
				if vim.wo.diff then return ']c' end
				vim.schedule(function() gitsigns.next_hunk() end)
				return '<Ignore>'
			end, { expr = true, desc = 'Next [H]unk' })

			vim.keymap.set('n', '[c', function()
				if vim.wo.diff then return '[c' end
				vim.schedule(function() gitsigns.prev_hunk() end)
				return '<Ignore>'
			end, { expr = true, desc = 'Previous [H]unk' })
		end
	},
	keys = {
		{ '<leader>gh', ':Gitsigns preview_hunk_inline<CR>',  desc = '[H]unk'  },
		{ '<leader>gb', ':Gitsigns blame<CR>',                desc = '[B]lame'  },
		{ '<leader>gr', ':Gitsigns reset_hunk<CR>',           desc = '[R]eset hunk'  },
	}

}
