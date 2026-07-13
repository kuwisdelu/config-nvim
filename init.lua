-- =============
-- NEOVIM CONFIG
-- by kuwisdelu
-- =============
-- NOTE: requires ripgrep, fd, fzf, tree-sitter-cli

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
	vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>")
	-- Create a new tab
	vim.keymap.set("n", "<Leader>t", "<Cmd>tabnew<CR>",
		{ desc = "New [T]ab" })
	-- Easy exit terminal
	vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>",
		{ desc = "Exit terminal mode" })
	-- Easy split navigation
	vim.keymap.set("n", "<C-h>", "<C-w><C-h>",
		{ desc = "Move focus to the left window" })
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>",
		{ desc = "Move focus to the right window" })
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>",
		{ desc = "Move focus to the lower window" })
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>",
		{ desc = "Move focus to the upper window" })
end

-- =======
-- PLUGINS
-- =======
-- Helper function for Github repos
local function gh(repo) return "https://github.com/" .. repo end
do
	-- Git signs
	vim.pack.add { gh "lewis6991/gitsigns.nvim" }
	require("gitsigns")
	-- Guess indentation
	vim.pack.add { gh "NMAC427/guess-indent.nvim" }
	require("guess-indent").setup {}
	-- Indentation guides
	vim.pack.add { gh "lukas-reineke/indent-blankline.nvim" }
	require("ibl").setup {}
	-- Colorscheme
	vim.pack.add { gh "folke/tokyonight.nvim" }
	require("tokyonight").setup {}
	vim.cmd.colorscheme "tokyonight-night"
	-- Comment highlighting
	vim.pack.add { gh "folke/todo-comments.nvim" }
	require("todo-comments").setup { signs = false }
	-- Display keymaps
	vim.pack.add { gh "folke/which-key.nvim" }
	require("which-key").setup {
		delay = 0,
		icons = { mappings = vim.g.have_nerd_font },
		spec = {
			{ "<Leader>f", group = "[F]ind", mode = { "n", "v" } },
		}
	}
	-- Quickfix improved
	vim.pack.add { gh "stevearc/quicker.nvim" }
	require("quicker").setup {}
	vim.keymap.set("n", "<C-q>", function() require("quicker").toggle() end,
		{ desc = "Toggle [Q]uickfix" })
	-- MINI.NVIM
	vim.pack.add { gh "nvim-mini/mini.nvim" }
	require("mini.icons").setup {}
	require("mini.statusline").setup {}
	require("mini.pick").setup {}
	vim.keymap.set("n", "<Leader>ff", "<Cmd>Pick files<CR>",
		{ desc = "[F]ind [F]iles" })
	vim.keymap.set("n", "<Leader>fg", "<Cmd>Pick grep_live<CR>",
		{ desc = "[F]ind by [G]rep" })
	vim.keymap.set("n", "<Leader>fb", "<Cmd>Pick buffers<CR>",
		{ desc = "[F]ind [B]uffers" })
	vim.keymap.set("n", "<Leader>fr", "<Cmd>Pick resume<CR>",
		{ desc = "[F]ind [R]esume" })
end

-- =======
-- PARSERS
-- =======
do
	vim.pack.add { gh "nvim-treesitter/nvim-treesitter" }
	local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 
		'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
	require("nvim-treesitter").install(parsers)
	local available = require("nvim-treesitter").get_available()
	-- Try attaching parser
	local function treesitter_try_attach(buf, language)
		if not vim.treesitter.language.add(language) then return end
		vim.treesitter.start(buf, language)
	end
	-- Tree installing and attaching parser
	local function treesitter_try_install_attach(buf, language)
		require("tree-sitter").install(language):await(
			function() treesitter_try_attach(buf, language) end)
	end
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local buf, filetype = args.buf, args.match
			local language = vim.treesitter.language.get_lang(filetype)
			if not language then
				return
			end
			local installed = require("nvim-treesitter").get_installed "parsers"
			if vim.tbl_contains(installed, language) then
				treesitter_try_attach(buf, language)
			elseif vim.tbl_contains(available, language) then
				treesitter_try_install_attach(buf, language)
			else
				treesitter_try_attach(buf, language)
			end
		end
	})
end

-- ==========
-- FILESYSTEM
-- ==========
do
	vim.pack.add { 
		{ src = gh "nvim-neo-tree/neo-tree.nvim" },
		gh "nvim-lua/plenary.nvim",
		gh "MunifTanjim/nui.nvim",
	}
	vim.keymap.set("n", "\\", "<Cmd>Neotree reveal<CR>",
		{ desc = "NeoTree reveal", silent = true })
	require("neo-tree").setup {
		filesystem = {
			window = {
				mappings = {
					["\\"] = "close_window",
				},
			},
		}
	}
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

