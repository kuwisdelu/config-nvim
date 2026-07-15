-- =============
-- NEOVIM CONFIG
-- by kuwisdelu
-- =============
-- NOTE: install ripgrep, fd, fzf, tree-sitter-cli

-- =======
-- OPTIONS
-- =======
do
	-- Enable faster startup by caching compiled Lua modules
	vim.loader.enable()		
	-- Font settings
	vim.g.have_nerd_font = false
	-- Filetype plugin
	vim.cmd("filetype plugin on")
	vim.cmd("filetype indent off")
	-- Indentation settings
	vim.o.expandtab = false
	vim.o.tabstop = 4
	vim.o.shiftwidth = 4
	vim.o.softtabstop = 0
	-- Language settings
	vim.g.python_recommended_style = 0
	-- Line numbering
	vim.o.number = true
	vim.o.relativenumber = true
	-- Line display
	vim.o.cursorline = true
	vim.o.breakindent = true
	vim.o.linebreak = true
	vim.o.signcolumn = "yes"
	vim.o.scrolloff = 10
	vim.o.list = true
	vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
	-- Mouse mode
	vim.o.mouse = "a"
	-- Sync OS clipboard
	vim.schedule(function() vim.o.clipboard = "unnamedplus" end)
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
	vim.o.inccommand = "split"
	-- Briefly highlight yanked text
	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Briefly highlight yanked test",
		callback = function() vim.hl.on_yank() end,
	})
end

-- =======
-- KEYMAPS
-- =======
do
	-- Leader and localleader keys
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "
	-- Clear search highlights on Esc
	vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>",
		{ desc = "Clear search highlights" })
	-- Create a new tab
	vim.keymap.set("n", "<Leader>t", "<Cmd>tabnew<CR>",
		{ desc = "New [T]ab" })
	-- Easy split navigation
	vim.keymap.set("n", "<C-h>", "<C-w><C-h>",
		{ desc = "Move focus to the left window" })
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>",
		{ desc = "Move focus to the right window" })
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>",
		{ desc = "Move focus to the lower window" })
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>",
		{ desc = "Move focus to the upper window" })
	-- Easy exit terminal
	vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>",
		{ desc = "Exit terminal mode" })
end

-- =======
-- PLUGINS
-- =======
-- Helper function for Github repos
local function gh(repo) return "https://github.com/" .. repo end
do
	-- MINI.NVIM
	vim.pack.add { gh "nvim-mini/mini.nvim" }
	require("mini.icons").setup {}
	require("mini.statusline").setup {}
	require("mini.indentscope").setup {}
	require("mini.diff").setup {
		view = {
			style = "sign",
			signs = { add = "+", change = "~", delete = "-" },
		},
	}
	require("mini.files").setup {
		mappings = { 
			close = "q",
			go_in_plus = "<CR>",
			go_out_plus = "<BS>",
			reset = "Q",
		},
	}
	vim.keymap.set("n", "\\", function() 
		if not MiniFiles.close() then MiniFiles.open() end end,
		{ desc = "Toggle files" })
	require("mini.pick").setup {}
	vim.keymap.set("n", "<Leader>ff", "<Cmd>Pick files<CR>",
		{ desc = "[F]ind [F]iles" })
	vim.keymap.set("n", "<Leader>fg", "<Cmd>Pick grep_live<CR>",
		{ desc = "[F]ind by [G]rep" })
	vim.keymap.set("n", "<Leader>fb", "<Cmd>Pick buffers<CR>",
		{ desc = "[F]ind [B]uffers" })
	vim.keymap.set("n", "<Leader>fr", "<Cmd>Pick resume<CR>",
		{ desc = "[F]ind [R]esume" })
	-- Guess indentation
	vim.pack.add { gh "NMAC427/guess-indent.nvim" }
	require("guess-indent").setup {}
	-- Comment highlighting
	vim.pack.add { gh "folke/todo-comments.nvim" }
	require("todo-comments").setup { signs = false }
	-- Colorscheme
	vim.pack.add { gh "folke/tokyonight.nvim" }
	require("tokyonight").setup {}
	vim.cmd.colorscheme "tokyonight-night"
	-- Quickfix improved
	vim.pack.add { gh "stevearc/quicker.nvim" }
	require("quicker").setup {}
	vim.keymap.set("n", "<C-q>", function() require("quicker").toggle() end,
		{ desc = "Toggle Quickfix" })
	-- Display keymaps
	vim.pack.add { gh "folke/which-key.nvim" }
	require("which-key").setup {
		delay = 0,
		icons = { mappings = vim.g.have_nerd_font },
		spec = {
			{ "<Leader>f", group = "[F]ind", mode = { "n", "v" } },
		}
	}
end

-- =======
-- PARSERS
-- =======
do
	vim.pack.add { { src = gh "nvim-treesitter/nvim-treesitter" } }
	local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc',
		'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
	require("nvim-treesitter").install(parsers)
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local lang = vim.treesitter.language.get_lang(args.match)
			if lang and vim.treesitter.language.add(lang) then
				vim.treesitter.start(args.buf, lang)
			end
		end,
	})
end

-- ====
-- REPL
-- ====
do
	local nvim_in_tmux = vim.env.TMUX ~= nil
	vim.g.slime_target = "tmux"
	vim.g.slime_no_mappings = true
	vim.g.slime_default_config = {
		socket_name = "default",
		target_pane = nvim_in_tmux and "{last}" or "",
	}
	vim.g.slime_dont_ask_default = nvim_in_tmux and 1 or 0
	vim.g.slime_bracketed_paste = 1
	vim.pack.add { gh "jpalardy/vim-slime" }
	vim.keymap.set("x", "<Leader>r", "<Plug>SlimeRegionSend",
		{ desc = "[R]un region" })
	vim.keymap.set("n", "<Leader>r", "<Plug>SlimeLineSend<CR>",
		{ desc = "[R]un line" })
	vim.keymap.set("n", "<Leader>m", "<Plug>SlimeMotionSend",
		{ desc = "Run [M]otion" })
	vim.keymap.set("n", "<Leader>p", "<Plug>SlimeParagraphSend",
		{ desc = "Run [P]aragraph" })
	vim.keymap.set("n", "<Leader>c", "<Plug>SlimeConfig",
		{ desc = "[C]hoose tmux target" })
end

