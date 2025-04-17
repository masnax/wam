return {
  { 'neovim/nvim-lspconfig', lazy = false },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  { 'nvim-treesitter/nvim-treesitter-refactor' },
  { 'nvim-treesitter/playground' },

  {'nvim-telescope/telescope.nvim', dependencies = {
    {'nvim-lua/plenary.nvim'},
    {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
  }},

  {'nvim-telescope/telescope-file-browser.nvim'},

  {'debugloop/telescope-undo.nvim'},
  { 'RRethy/nvim-treesitter-textsubjects' },

  { 'ray-x/lsp_signature.nvim' },
  { 'ray-x/go.nvim' },
  { 'norcalli/nvim-colorizer.lua'},
  { 'folke/paint.nvim' },
  { 'masnax/sunset-vim' },
  { 'kyazdani42/nvim-web-devicons' },
  { 'lambdalisue/glyph-palette.vim' },
  { 'rose-pine/neovim', name = 'rose-pine' },
  { "catppuccin/nvim", name = "catppuccin" },
  { 'kevinhwang91/nvim-ufo', dependencies = { 'kevinhwang91/promise-async' }},
  { 'jghauser/fold-cycle.nvim' },
  { 'windwp/nvim-autopairs' },
  { 'SmiteshP/nvim-navic' },
  { 'HiPhish/rainbow-delimiters.nvim' },
  { 'lewis6991/gitsigns.nvim' },
  { 'lukas-reineke/indent-blankline.nvim' },
  { 'smjonas/inc-rename.nvim' },

  { 'noib3/nvim-cokeline', dependencies = { 'kyazdani42/nvim-web-devicons' }},
  { 'masnax/feline.nvim' },
  { 'sindrets/diffview.nvim' },
  { 'folke/noice.nvim', dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" } },
  { "jackMort/ChatGPT.nvim", dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" } },

  { 'CosmicNvim/cosmic-ui',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    config = function() require('cosmic-ui').setup() end
  },

  { 'phaazon/hop.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
      vim.api.nvim_set_keymap('v', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
      vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
      vim.api.nvim_set_keymap('v', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
      require'hop'.setup({keys = "123456789abcdefghijklmnopqrstuvwxyz"})
    end
  },

  { 'hrsh7th/nvim-cmp', dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'onsails/lspkind-nvim',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  }},
}
