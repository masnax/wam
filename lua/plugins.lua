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
       -- ["keymap.preview"] = {"Space"},
      })
    end
  }

  -- LSP
  use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
  use 'ray-x/lsp_signature.nvim'
  use {'ray-x/starry.nvim'}
  use {'masnax/navigator.lua', requires = {'masnax/guihua.lua', run = 'cd lua/fzy && make'}}

  -- Colorscheme
  use 'norcalli/nvim-colorizer.lua'
  use { 'masnax/sunset-vim' }
  use { 'kyazdani42/nvim-web-devicons' }
  use { 'lambdalisue/glyph-palette.vim' }
  use { 'CosmicNvim/cosmic-ui',
    requires = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    config = function() require('cosmic-ui').setup() end
  }
  use { 'phaazon/hop.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
      vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
      require'hop'.setup({keys = "asdfghjklqwertyuiopzxcvbnm"})
    end 
  }
  use{ 'anuvyklack/pretty-fold.nvim' }
  use { 'jghauser/fold-cycle.nvim' }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }
  use { 'nvim-treesitter/nvim-treesitter-refactor' }
  use { 'nvim-treesitter/playground' }
  use { 'RRethy/nvim-treesitter-textsubjects' }
  use { 'windwp/nvim-autopairs' }
  use { 'p00f/nvim-ts-rainbow' }
  use {'lewis6991/gitsigns.nvim'}


  -- Menus
  use { 'noib3/nvim-cokeline', requires = 'kyazdani42/nvim-web-devicons' }
end)
