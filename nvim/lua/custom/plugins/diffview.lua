return {
	'sindrets/diffview.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	opts = {
		use_icons = false,
		view = { merge_tool = { layout = 'diff3_mixed' } }
	}
}
