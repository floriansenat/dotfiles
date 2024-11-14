return {
	'stevearc/quicker.nvim',
	event = "FileType qf",
	opts = {
		keys = {
			{
				">",
				":lua require'quicker'.expand { before = 2, after = 2, add_to_existing = true } <CR>",
				 desc = "Expand quickfix context" ,
			},
			{
				"<",
				":lua require'quicker'.collapse()<CR>",
				 desc = "Collapse quickfix context", 
			},
		},
	},
}
