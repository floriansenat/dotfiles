local is_dark = true

local function get_theme()
	if is_dark then return 'dark' end
	return 'light'
end

local function toggle_theme()
	is_dark = not is_dark
	vim.o.background = get_theme()
end

return {
	'sainnhe/everforest',
	priority = 1000,
	config = function()
		vim.cmd.colorscheme('everforest')
		vim.api.nvim_create_user_command('ToggleTheme', toggle_theme, {})
		vim.keymap.set('n', '<leader>t', '<cmd>ToggleTheme<CR>', { desc = 'Toggle [T]heme' })
	end,
}
