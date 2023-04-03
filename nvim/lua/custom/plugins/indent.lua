-- See `:help indent_blankline.txt`
return {
	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		opts = {
			char = '┊',
			show_trailing_blankline_indent = false,
		},
	}
}
