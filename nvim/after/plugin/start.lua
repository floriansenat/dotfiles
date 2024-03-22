local fzf = require('fzf-lua');

vim.api.nvim_create_autocmd('VimEnter', {
	callback = function()
		fzf.files()
	end
})
