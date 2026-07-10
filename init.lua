-- =============
-- NEOVIM CONFIG
-- by kuwisdelu
-- =============
-- NOTE: requires ripgrep, fd, fzf

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
end

-- =======
-- KEYMAPS
-- =======
do
	-- Leader and localleader keys
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "
	-- Clear search highlights on Esc
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
	-- Create a new tab
	vim.keymap.set("n", "<leader>t", "<cmd>tabnew<CR>",
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
	-- Briefly highlight yanked text
	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Briefly highlight yanked test",
		callback = function() vim.hl.on_yank() end,
	})
end

-- =======
-- PLUGINS
-- =======
-- Helper function for Github repos
local function gh(repo) return "https://github.com/" .. repo end
do
	-- Guess indentation
	vim.pack.add { gh "NMAC427/guess-indent.nvim" }
	require("guess-indent").setup {}
	-- Git signs
	vim.pack.add { gh "lewis6991/gitsigns.nvim" }
	require("gitsigns")
	-- Indentation guides
	vim.pack.add { gh "lukas-reineke/indent-blankline.nvim" }
	require("ibl").setup {}
	-- Display keymaps
	vim.pack.add { gh "folke/which-key.nvim" }
	require("which-key").setup {
		delay = 0,
		icons = { mappings = vim.g.have_nerd_font },
		spec = {
			{ "<leader>f", group = "[F]ind", mode = { "n", "v" } },
		}
	}
	-- Colorscheme
	vim.pack.add { gh "folke/tokyonight.nvim" }
	require("tokyonight").setup {}
	vim.cmd.colorscheme "tokyonight-night"
	-- Comment highlighting
	vim.pack.add { gh "folke/todo-comments.nvim" }
	require("todo-comments").setup { signs = false }
	-- MINI.NVIM
	vim.pack.add { gh "nvim-mini/mini.nvim" }
	require("mini.icons").setup {}
	require("mini.ai").setup {}
	require("mini.surround").setup {}
	require("mini.statusline").setup {}
end

-- ======
-- PICKER
-- ======
do
	local telescope_plugins = {
		gh "nvim-lua/plenary.nvim",
		gh "nvim-telescope/telescope.nvim",
		gh "nvim-telescope/telescope-ui-select.nvim",
		gh "nvim-telescope/telescope-live-grep-args.nvim",
	}
	if vim.fn.executable 'make' == 1 then
		table.insert(telescope_plugins,
			gh "nvim-telescope/telescope-fzf-native.nvim")
	end
	vim.pack.add(telescope_plugins)
	require("telescope").setup {
		extensions = {
			live_grep_args = { autoquoting = true },
		}
	}
	pcall(require("telescope").load_extension, "fzf")
	pcall(require("telescope").load_extension, "ui-select")
	pcall(require("telescope").load_extension, "live_grep_args")
	do
		local builtin = require "telescope.builtin"
		vim.keymap.set("n", "<leader>ff", builtin.find_files,
			{ desc = "[F]ind [F]iles" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep,
			{ desc = "[F]ind by [G]rep" })
		vim.keymap.set("n", "<leader>fr", builtin.resume,
			{ desc = "[F]ind [R]esume" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers,
			{ desc = "[F]ind [B]uffer" })
		vim.keymap.set("n", "<leader>fa", function()
			require("telescope").extensions.live_grep_args.live_grep_args() end,
			{ desc = "[F]ind by Grep with [A]rgs" })
		vim.keymap.set("n", "<leader>f/", builtin.current_buffer_fuzzy_find,
			{ desc = "[F]ind fuzzily in current buffer" })
	end
end

-- ====
-- TREE 
-- ====
do
	vim.pack.add { 
		{ src = gh "nvim-neo-tree/neo-tree.nvim" },
		gh "nvim-lua/plenary.nvim",
		gh "MunifTanjim/nui.nvim",
	}
	vim.keymap.set("n", "\\", "<cmd>Neotree reveal<CR>",
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
	vim.keymap.set("x", "<leader>r", "<Plug>SlimeRegionSend",
		{ desc = "[R]un region" })
	vim.keymap.set("n", "<leader>r", "<Plug>SlimeLineSend",
		{ desc = "[R]un lines" })
	vim.keymap.set("n", "<leader>m", "<Plug>SlimeMotionSend",
		{ desc = "Run [M]otion" })
	vim.keymap.set("n", "<leader>p", "<Plug>SlimeParagraphSend",
		{ desc = "Run [P]aragraph" })
	vim.keymap.set("n", "<leader>c", "<Plug>SlimeConfig",
		{ desc = "[C]onfigure tmux target" })
end

