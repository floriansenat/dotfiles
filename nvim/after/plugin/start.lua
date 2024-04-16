vim.api.nvim_create_autocmd('VimEnter', {
	callback = function()
		local builtin = require('telescope.builtin');
		local buffer = vim.api.nvim_get_current_buf()
		local bufferName = vim.api.nvim_buf_get_name(buffer)

		if bufferName == '' then
			builtin.find_files()
		end
	end
})
