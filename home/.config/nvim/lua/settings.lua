vim.o.hlsearch = false
vim.wo.number = true
vim.o.mouse = 'a'
vim.o.termguicolors = true
vim.o.relativenumber = true
vim.o.scrolloff = 8

vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.o.breakindent = true
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.undofile = true

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Hides the command bar when not used
vim.o.cmdheight = 0
