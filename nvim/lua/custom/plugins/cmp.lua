function select_next_item(fallback)
	local luasnip = require 'luasnip'
	local cmp = require 'cmp'

	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	else
		fallback()
	end
end

function select_prev_item(fallback)
	local luasnip = require 'luasnip'
	local cmp = require 'cmp'

	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end

return {
	'hrsh7th/nvim-cmp',
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		{ 'L3MON4D3/LuaSnip', version = "v2.*", build = "make install_jsregexp" },
		'saadparwaiz1/cmp_luasnip'
	},
	config = function()
		local cmp = require 'cmp'
		local luasnip = require 'luasnip'

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert {
				['<C-d>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete {},
				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				},
				['<Tab>'] = cmp.mapping(select_next_item, { 'i', 's' }),
				['<S-Tab>'] = cmp.mapping(select_prev_item, { 'i', 's' }),
			},
			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
			},
		})
	end
}
