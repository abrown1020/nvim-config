-- plugins.lua
return {
  {
    'SmiteshP/nvim-navic',
    event = 'LspAttach', -- lazy-load when any LSP attaches
    opts = {
      lsp = { auto_attach = true }, -- automatically call navic.attach()
    },
  },
  {
    'LunarVim/breadcrumbs.nvim',
    dependencies = { 'SmiteshP/nvim-navic' },
    event = 'LspAttach',
    config = function()
      require('breadcrumbs').setup()
    end,
  },
}
