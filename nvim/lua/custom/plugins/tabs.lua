return {
	{
		'akinsho/bufferline.nvim',
		version = "v3.*",
		config = function()
			require("bufferline").setup({
				options = {
					-- separator_style = "slope",
					indicator = {
						style = 'underline'
					},
					buffer_close_icon = 'x',
					close_icon = 'x',
					left_trunc_marker = '',
					right_trunc_marker = '',
				}
			})
		end
	}
}
