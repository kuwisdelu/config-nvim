-- =======
-- OPTIONS
-- =======
do
	-- Enable faster startup by caching compiled Lua modules
	vim.loader.enable()		
	-- Font settings
	vim.g.have_nerd_font = false
	-- Indentation settings
	vim.o.expandtab = false
	vim.o.tabstop = 4
	vim.o.shiftwidth = 0
	vim.o.softtabstop = -1
	-- Language settings
	vim.g.python_recommended_style = 0
	-- Line numbering
	vim.o.number = true
	vim.o.relativenumber = true
	-- Line display
	vim.o.cursorline = true
	vim.o.breakindent = true
	vim.o.signcolumn = 'yes'
	vim.o.scrolloff = 10
	vim.o.list = true
	vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
	-- Mouse mode
	vim.o.mouse = 'a'
	-- Sync OS clipboard
	vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
	-- Undo and confirm changes
	vim.o.undofile = true
	vim.o.confirm = true
	-- Case sensitivity
	vim.o.ignorecase = true
	vim.o.smartcase = true
	-- Splits
	vim.o.splitright = true
	vim.o.splitbelow = true
	-- Live substitutions
	vim.o.inccommand = 'split'
end

-- =======
-- KEYMAPS
-- =======
do
	-- Leader and localleader keys
	vim.g.mapleader = ' '
	vim.g.maplocalleader = ' '
	-- Clear search highlights on Esc
	vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
	-- Create a new tab
	vim.keymap.set('n', '<leader>t', '<cmd>tabnew<CR>', { desc = 'New [T]ab' })
	-- Easy exit terminal
	vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
	-- Easy split navigation
	vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
	vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
	vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
	vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
	-- Briefly highlight yanked text
	vim.api.nvim_create_autocmd('TextYankPost', {
		desc = "Briefly highlight yanked test",
		callback = function() vim.hl.on_yank() end,
	})
end

-- =======
-- PLUGINS
-- =======
-- Helper function for Github repos
local function gh(repo) return 'https://github.com/' .. repo end
do
	-- Guess indentation settings
	vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
	require('guess-indent').setup {}
	-- Git signs
	vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
	require('gitsigns')
end
