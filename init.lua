local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require("vim")
require("plugins")
require("theme")
require("theme-editor")
require("syntax")
require("lsp/go")
require("ts/def-impl")
require("git")
require("fold")
require("bufline")
require("statusline")
require("gui")
require("ai")
require'colorizer'.setup()
