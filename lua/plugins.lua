-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Coq
  use { 'ms-jpq/coq_nvim',  branch = 'coq'}

  use { 'ms-jpq/coq.artifacts', branch = 'artifacts'}

  -- use { 'ms-jpq/coq.artifacts', branch = 'artifacts' }
  -- LSP
  use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
  use 'ray-x/lsp_signature.nvim'
  use {'ray-x/navigator.lua', requires = {'ray-x/guihua.lua', run = 'cd lua/fzy && make'}}

  -- Colorscheme
  use 'norcalli/nvim-colorizer.lua'
  use { 'masnax/sunset-vim',
    config = function()
      vim.cmd([[colorscheme tangerine]])
    end,
  }
  use { 'kyazdani42/nvim-web-devicons' }
  use { 'lambdalisue/glyph-palette.vim' }


  ---- Simple plugins can be specified as strings
  use '9mm/vim-closer'
  use { 'phaazon/hop.nvim',
  config = function()
    vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
    vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
    require'hop'.setup({
      keys = "asdfghjklqwertyuiopzxcvbnm",

    })
  end
 }

 use{ 'anuvyklack/pretty-fold.nvim',
 config = function()
   require('pretty-fold').setup()
   require('pretty-fold.preview').setup()
 end
  }

  ---- Lazy loading:
  ---- Load on specific commands
  --use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

  ---- Load on an autocommand event
  --use {'andymass/vim-matchup', event = 'VimEnter'}

  ---- Load on a combination of conditions: specific filetypes or commands
  ---- Also run code after load (see the "config" key)
  --use {
  --  'w0rp/ale',
  --  ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
  --  cmd = 'ALEEnable',
  --  config = 'vim.cmd[[ALEEnable]]'
  --}

  ---- Plugins can have dependencies on other plugins
  --use {
  --  'haorenW1025/completion-nvim',
  --  opt = true,
  --  requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
  --}

  ---- Plugins can also depend on rocks from luarocks.org:
  --use {
  --  'my/supercoolplugin',
  --  rocks = {'lpeg', {'lua-cjson', version = '2.1.0'}}
  --}

  ---- You can specify rocks in isolation
  --use_rocks 'penlight'
  --use_rocks {'lua-resty-http', 'lpeg'}

  ---- Local plugins can be included
  --use '~/projects/personal/hover.nvim'

  ---- Plugins can have post-install/update hooks
  --use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }
  use { 'nvim-treesitter/nvim-treesitter-refactor' }
  use { 'nvim-treesitter/playground' }
  use { 'RRethy/nvim-treesitter-textsubjects' }
  use { 'windwp/nvim-autopairs' }
  use { 'p00f/nvim-ts-rainbow' }

  ---- Post-install/update hook with call of vimscript function with argument
  --use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  ---- Use specific branch, dependency and run lua file after load
  --use {
  --  'glepnir/galaxyline.nvim', branch = 'main', config = function() require'statusline' end,
  --  requires = {'kyazdani42/nvim-web-devicons'}
  --}

  ---- Use dependency and run lua function after load
  use {'lewis6991/gitsigns.nvim'}

  ---- You can specify multiple plugins in a single call
  --use {'tjdevries/colorbuddy.vim', {'nvim-treesitter/nvim-treesitter', opt = true}}

  ---- You can alias plugin names
  use {'dracula/vim', as = 'dracula'}

  use({
    'CosmicNvim/cosmic-ui',
    requires = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
      require('cosmic-ui').setup()
    end,
  })
end)
