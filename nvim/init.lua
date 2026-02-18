-- General Setup
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.cmd([[hi CursorLine guibg=#2C2C2C ctermbg=236]])

-- Explorer
vim.g.netrw_banner = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 50
vim.keymap.set('n', '<leader>e', ':Lexplore<CR>', { silent = true })

-- Folding
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.mouse = 'a'
vim.opt.fillchars = { fold = ' ', foldopen = 'v', foldclose = '>' }

-- Custom Tabbing
vim.opt.list = true
vim.opt.listchars = { tab = "│  " }
