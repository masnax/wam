-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Coq
  use { 'ms-jpq/coq_nvim',  branch = 'coq'}
  use { 'ms-jpq/coq.artifacts', branch = 'artifacts'}
  use { 'ms-jpq/chadtree', branch = 'chad',
    config = function()
      vim.api.nvim_set_var("chadtree_settings", {
        ["keymap.trash"] = {},
        ["keymap.tertiary"] = {"t"},
        ["keymap.quit"] = {"q", ";'", "';"},
        ["keymap.collapse"] = {"<s-tab>","<s-up>"},
        ["keymap.Change_focus_up"] = {"C", "<m-up>"},
        ["keymap.change_focus"] = {"c", "<m-down>"},
        ["keymap.secondary"] = {"Space", "<s-enter>"},
      })
    end
  }

  -- LSP
  use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
  use 'ray-x/lsp_signature.nvim'
  use 'ray-x/go.nvim'
  -- use {'ray-x/starry.nvim'}
  -- use {'masnax/navigator.lua', branch = 'edits', requires = {'masnax/guihua.lua', branch = 'edits', run = 'cd lua/fzy && make'}}
  use {"https://git.sr.ht/~whynothugo/lsp_lines.nvim"}



  -- Search
  use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/plenary.nvim'}}

  -- Colorscheme
  use 'norcalli/nvim-colorizer.lua'
  use { 'folke/paint.nvim' }
  use { 'masnax/sunset-vim' }
  use { 'kyazdani42/nvim-web-devicons' }
  use { 'lambdalisue/glyph-palette.vim' }
  use { 'CosmicNvim/cosmic-ui',
    requires = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    config = function() require('cosmic-ui').setup() end
  }
  use({
    "catppuccin/nvim",
    as = "catppuccin"
  })

  use({ 'rose-pine/neovim', as = 'rose-pine', tag = 'v1.*', })

  use { 'phaazon/hop.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
      vim.api.nvim_set_keymap('v', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
      vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
      vim.api.nvim_set_keymap('v', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
      require'hop'.setup({keys = "asdfghjklqwertyuiopzxcvbnm"})
    end
  }
  use{ 'anuvyklack/pretty-fold.nvim', requires = {"anuvyklack/nvim-keymap-amend"} }
  use { 'jghauser/fold-cycle.nvim' }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }
  use { 'nvim-treesitter/nvim-treesitter-refactor' }
  use { 'nvim-treesitter/playground' }
  use { 'RRethy/nvim-treesitter-textsubjects' }
  use { 'windwp/nvim-autopairs' }
  use { 'SmiteshP/nvim-gps' }
  use { 'p00f/nvim-ts-rainbow' }
  use {'lewis6991/gitsigns.nvim'}
  use { 'lukas-reineke/indent-blankline.nvim' }


  -- Menus
  use { 'noib3/nvim-cokeline', requires = 'kyazdani42/nvim-web-devicons' }
  use { 'feline-nvim/feline.nvim' }
  use{ 'folke/noice.nvim', requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" } }
end)
