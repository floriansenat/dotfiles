return {
	'mbbill/undotree',
	lazy = true,
	init = function() vim.g.undotree_WindowLayout = 2 end,
	keys = {
		{ '<leader>ut', ':UndotreeToggle<CR>',  desc = '[T]oggle'  },
		{ '<leader>uf', ':UndotreeFocus<CR>',   desc = '[F]ocus'  },

	}
}
