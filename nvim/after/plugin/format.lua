	local format_is_enabled = true

vim.api.nvim_create_user_command('ToggleFormat', function()
	format_is_enabled = not format_is_enabled
	print('Autoformatting is now: ' .. tostring(format_is_enabled))
end, {})

vim.api.nvim_create_augroup('AutoFormatting', {})

vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = '*.lua',
	group = 'AutoFormatting',
	callback = function()
		if format_is_enabled then
			vim.lsp.buf.format({ async = true })
		end
	end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
	group = 'AutoFormatting',
	callback = function()
		if format_is_enabled then
			vim.cmd('silent! EslintFixAll')
		end
	end
})
