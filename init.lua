-- Load general config
require 'core.options'
require 'core.keymaps'
-- require 'core.snippets'

-- Set up Lazy plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv or not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Set up plugins
require('lazy').setup {
  { import = 'plugins' },
  { import = 'plugins.lsp' },
  checker = {
    enabled = false,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
}

-- Configure pwsh
vim.opt.shell = 'pwsh'
vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
-- vim.opt.shellquote = ''
-- vim.opt.shellxquote = ''

local shada_path = vim.fn.stdpath 'data' .. '/shada'
local glob_pattern = shada_path .. '/main.shada.tmp.*'

for _, file in ipairs(vim.fn.glob(glob_pattern, true, true)) do
  os.remove(file)
end

-- explicit winbar assignment (only if you’ve disabled the default)
vim.opt.winbar = "%{%v:lua.require'breadcrumbs'.get_winbar()%}"
vim.opt.showtabline = 0

vim.o.termguicolors = true
require('core.colors').apply()

-- require('nvim-web-devicons').set_icon {
--   rs = {
--     icon = '🦀',
--     color = '#ff6c6b',
--     name = 'Rs',
--   },
-- }
-- Create (or clear) an augroup for our TeX wrapping settings
-- vim.api.nvim_create_augroup('TeXWrap', { clear = true })

-- Whenever a TeX buffer is opened...
-- vim.api.nvim_create_autocmd('FileType', {
--   group = 'TeXWrap',
--   pattern = { 'tex', 'plaintex' },
--   callback = function()
--     -- enable visual line wrapping
--     vim.opt_local.wrap = true
--     -- break at word boundaries, not mid-word
--     vim.opt_local.linebreak = true
--     -- preserve indent for wrapped lines
--     vim.opt_local.breakindent = true
--   end,
-- })
