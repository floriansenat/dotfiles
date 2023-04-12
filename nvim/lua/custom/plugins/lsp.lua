return {
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'williamboman/mason.nvim',          config = true },
			{ 'illiamboman/mason-lspconfig.nvim', config = true },
			{ 'j-hui/fidget.nvim',                config = true },
			{ 'folke/neodev.nvim',                config = true },
		},
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

			local lspconfig = require('lspconfig')
			lspconfig.tsserver.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				Lua = {
					yorkspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			})

			require('mason-lspconfig').setup({ ensure_installed = { "tsserver", "lua_ls" } })
		end
	}
}
