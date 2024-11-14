local format_is_enabled = true

vim.api.nvim_create_user_command('ToggleFormat', function()
	format_is_enabled = not format_is_enabled
	print('AutoFormatting is now: ' .. tostring(format_is_enabled))
end, {})

vim.api.nvim_create_augroup('AutoFormatting', {})

local langs = {
	lua = {
		pattern = { '*.lua' },
		callback = function()
			vim.lsp.buf.format({ async = true })
		end
	},
	json = {
		pattern = { '*.json' },
		callback = function()
			vim.cmd('silent! %!jq .')
		end
	},
	typescript = {
		pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
		callback = function()
			vim.cmd('silent! EslintFixAll')
		end
	}
}

for _, lang in pairs(langs) do
	vim.api.nvim_create_autocmd('BufWritePre', {
		pattern = lang.pattern,
		group = 'AutoFormatting',
		callback = function()
			if format_is_enabled then
				lang.callback()
			end
		end,
	})
end
