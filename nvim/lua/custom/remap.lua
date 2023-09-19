vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- Can move lines up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Keep cursor centered when moving
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- [[Project]]
vim.keymap.set('n', '<leader>pe', vim.cmd.Ex, { silent = true, desc = "Show [E]xplorer" })

-- [[Diagnostic]]
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = "[P]rev" })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = "[N]ext" })
vim.keymap.set('n', '<leader>dm', vim.diagnostic.open_float, { desc = "[M]essage" })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = "[L]ist" })

-- [[LSP]]
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function()
		vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = '[R]ename' })
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[A]ction' })
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })
		vim.keymap.set('n', '<leader>Fb', vim.lsp.buf.format, { desc = '[B]uffer' })
		vim.keymap.set('n', '<leader>Ft', '<cmd>ToggleFormat<CR>', { desc = '[T]oggle' })
	end
})

-- [[Files]]
vim.keymap.set('n', '<leader>fc', '<cmd>let @*=expand("%")<CR>', { desc = '[C]opy file path' })
