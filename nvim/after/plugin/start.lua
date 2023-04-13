local builtin = require('telescope.builtin');

vim.api.nvim_create_autocmd('VimEnter', {
	callback = function()
		builtin.find_files()
	end
})
