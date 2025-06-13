vim.g.mapleader = ";"
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

-- Disable swap file creation (for fewer temporary files)
vim.opt.swapfile = false

-- Directory to store undo history files for larger history
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Do not highlight matches after search
vim.opt.hlsearch = false

-- Show matches while typing a search query
vim.opt.incsearch = true

-- True color support in the terminal
vim.opt.termguicolors = true

-- Keep 8 lines of context above and below the cursor when scrolling
vim.opt.scrolloff = 8

-- Always show the sign column (for git signs etc.)
vim.opt.signcolumn = "yes"

-- Allow '@' as a valid character in filenames
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
