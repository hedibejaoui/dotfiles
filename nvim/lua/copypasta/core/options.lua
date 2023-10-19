local opt = vim.opt

opt.autoindent = true -- copy indent from current line when starting new one
opt.smartindent = true
opt.breakindent = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

opt.wrap = false -- disable line wrapping

opt.incsearch = true

opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.termguicolors = true -- set termguicolors to enable highlight groups

opt.cursorline = true -- highlight the current cursor line

opt.scrolloff = 8
opt.signcolumn = "yes"

opt.swapfile = false

-- Sync clipboard between OS and Neovim.
opt.clipboard = 'unnamedplus'

-- Save undo history
opt.undofile = true

-- Decrease update time
opt.updatetime = 250
opt.timeoutlen = 0

-- Set completeopt to have a better completion experience
opt.completeopt = 'menuone,noselect'


