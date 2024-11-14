return {
	{
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
			{ '<leader>dh', ':Gitsigns preview_hunk_inline<CR>', desc = '[H]unk' },
			{ '<leader>db', ':Gitsigns blame<CR>',               desc = '[B]lame' },
			{ '<leader>dr', ':Gitsigns reset_hunk<CR>',          desc = '[R]eset hunk' },
		}
	},
	{
		'sindrets/diffview.nvim',
		lazy = true,
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {
			use_icons = false,
			view = { merge_tool = { layout = 'diff3_mixed' } }
		},
		keys = {
			{ '<leader>do', ':DiffviewOpen<CR>',          desc = '[O]pen' },
			{ '<leader>dc', ':DiffviewClose<CR>',         desc = '[C]lose' },
			{ '<leader>df', ':DiffviewFileHistory %<CR>', desc = '[F]ile' },
		}
	},
	{
		'mbbill/undotree',
		lazy = true,
		init = function() vim.g.undotree_WindowLayout = 2 end,
		keys = {
			{ '<leader>du', ':UndotreeToggle<CR>', desc = '[U]ndotree' },
		}
	}

}
