return {
	'mbbill/undotree',
	config = function()
		vim.g.undotree_WindowLayout = 2
		vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle, { desc = '[T]oggle' })
		vim.keymap.set('n', '<leader>uf', vim.cmd.UndotreeFocus, { desc = '[F]ocus' })
	end
}
