-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim'}

  use { 'neovim/nvim-lspconfig' } -- Collection of configurations for the built-in LSP client

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }
  use { 'nvim-treesitter/nvim-treesitter-refactor' }
  use { 'nvim-treesitter/playground' }

  use {'nvim-telescope/telescope.nvim', requires = {
    {'nvim-lua/plenary.nvim'},
    {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
  }}
  use {'nvim-telescope/telescope-file-browser.nvim'}

  use {'debugloop/telescope-undo.nvim'}
  use { 'RRethy/nvim-treesitter-textsubjects' }

  use { 'ray-x/lsp_signature.nvim' }
  use { 'ray-x/go.nvim' }
  use { 'norcalli/nvim-colorizer.lua'}
  use { 'folke/paint.nvim' }
  use { 'masnax/sunset-vim' }
  use { 'kyazdani42/nvim-web-devicons' }
  use { 'lambdalisue/glyph-palette.vim' }
  use { 'rose-pine/neovim', as = 'rose-pine' }
  use { "catppuccin/nvim", as = "catppuccin" }
  use { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' }
  use { 'jghauser/fold-cycle.nvim' }
  use { 'windwp/nvim-autopairs' }
  use { 'SmiteshP/nvim-navic' }
  use { 'HiPhish/rainbow-delimiters.nvim' }
  use {'lewis6991/gitsigns.nvim'}
  use { 'lukas-reineke/indent-blankline.nvim' }
  use { 'danielfalk/smart-open.nvim', branch = "0.1.x", requires = {"kkharji/sqlite.lua"} }
  use { 'smjonas/inc-rename.nvim' }

  use { 'noib3/nvim-cokeline', requires = 'kyazdani42/nvim-web-devicons' }
  use { 'masnax/feline.nvim' }
  use { 'sindrets/diffview.nvim' }
  use { 'folke/noice.nvim', requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" } }
  use { "jackMort/ChatGPT.nvim", requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" } }

  use { 'CosmicNvim/cosmic-ui',
    requires = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    config = function() require('cosmic-ui').setup() end
  }

  use { 'phaazon/hop.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
      vim.api.nvim_set_keymap('v', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
      vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
      vim.api.nvim_set_keymap('v', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
      require'hop'.setup({keys = "asdfghjklqwertyuiopzxcvbnm"})
    end
  }

  use { 'hrsh7th/nvim-cmp', requires = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'onsails/lspkind-nvim',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  }}
end)
