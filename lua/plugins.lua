return {
  { 'neovim/nvim-lspconfig', lazy = false },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', branch = "main" },
  { 'nvim-treesitter/nvim-treesitter-textobjects', branch = "main" },
  { 'nvim-treesitter/nvim-treesitter-locals', branch = "main" },

  {'nvim-telescope/telescope.nvim', dependencies = {
    {'nvim-lua/plenary.nvim'},
    {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
  }},

  {'nvim-telescope/telescope-file-browser.nvim'},

  { 'ray-x/lsp_signature.nvim' },
  { 'ray-x/go.nvim' },
  { 'ray-x/guihua.lua' },
  { 'norcalli/nvim-colorizer.lua'},
  { 'folke/paint.nvim' },
  { 'masnax/sunset-vim' },
  { 'kyazdani42/nvim-web-devicons' },
  { 'lambdalisue/glyph-palette.vim' },
  { 'rose-pine/neovim', name = 'rose-pine' },
  { "catppuccin/nvim", name = "catppuccin" },
  { 'kevinhwang91/nvim-ufo', dependencies = { 'kevinhwang91/promise-async' }},
  { 'jghauser/fold-cycle.nvim' },
  { 'saghen/blink.pairs', version = '*', dependencies = 'saghen/blink.download' },
  { 'SmiteshP/nvim-navic' },
  { 'HiPhish/rainbow-delimiters.nvim' },
  { 'lewis6991/gitsigns.nvim' },
  { 'lukas-reineke/indent-blankline.nvim' },
  { 'smjonas/inc-rename.nvim' },

  { 'noib3/nvim-cokeline', dependencies = { 'kyazdani42/nvim-web-devicons' }},
  { 'masnax/feline.nvim' },
  { 'sindrets/diffview.nvim' },
  { 'folke/noice.nvim', dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" } },

  { 'CosmicNvim/cosmic-ui',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    config = function() require('cosmic-ui').setup() end
  },

  --{ "sphamba/smear-cursor.nvim", opts = { cursor_color = "#d3cdc3"} },

  { 'phaazon/hop.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
      vim.api.nvim_set_keymap('v', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
      vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
      vim.api.nvim_set_keymap('v', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
      require'hop'.setup({keys = "123456789abcdefghijklmnopqrstuvwxyz"})
    end
  },

  { 'saghen/blink.cmp', dependencies = {
    'rafamadriz/friendly-snippets',
    { "samiulsami/cmp-go-deep", dependencies = { "kkharji/sqlite.lua" } },
    { "saghen/blink.compat" },

  }, version = '1.*', },
  { "L3MON4D3/LuaSnip", build = "make install_jsregexp",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  },
	{ 'samiulsami/cmp-go-deep', dependencies = { 'kkharji/sqlite.lua', 'saghen/blink.compat' }, },

  { "pmizio/typescript-tools.nvim", dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" }, opts = {
    on_attach = function()
      local lsp_opts = { noremap=true, silent=true }
      vim.api.nvim_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_prev({float=false})<CR>', lsp_opts)
      vim.api.nvim_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.jump({count=1, float=false})<CR>', lsp_opts)
      vim.api.nvim_set_keymap('n', 'E', '<cmd>lua vim.diagnostic.open_float()<CR>', lsp_opts)
      vim.api.nvim_set_keymap('n', '?', '<cmd>lua vim.lsp.buf.hover()<CR>', lsp_opts)
      vim.api.nvim_set_keymap('n', 'C', '<cmd>lua vim.lsp.buf.code_action()<CR>', lsp_opts)
      vim.api.nvim_exec(
        [[
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]],
        false
      )
    end,
  }, }
}
