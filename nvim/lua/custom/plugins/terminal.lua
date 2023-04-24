return {
	'akinsho/toggleterm.nvim',
	version = "*",
	config = function()
		local function toggle_lazygit()
			local Terminal = require('toggleterm.terminal').Terminal
			Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" }):toggle()
		end

		vim.api.nvim_create_user_command('ToggleLazygit', toggle_lazygit, {})
		vim.keymap.set("n", "<leader>g", "<cmd>ToggleLazygit<CR>",
			{ desc = "[G]it", noremap = true, silent = true })
	end
}
