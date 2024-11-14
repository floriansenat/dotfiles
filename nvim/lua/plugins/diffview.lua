return {
	'sindrets/diffview.nvim',
	lazy = true,
	dependencies = { 'nvim-lua/plenary.nvim' },
	opts = {
		use_icons = false,
		view = { merge_tool = { layout = 'diff3_mixed' } }
	},
	keys = {
		{ '<leader>do', ':DiffviewOpen<CR>',           desc = '[O]pen'  },
		{ '<leader>dq', ':DiffviewClose<CR>',          desc = '[Q]uit'  },
		{ '<leader>df', ':DiffviewFileHistory %<CR>',  desc = '[F]ile'  },
	}
}
