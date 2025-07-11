return {
  {
    'nvimtools/none-ls.nvim',
    config = function()
      local null_ls = require 'null-ls'
      null_ls.setup {
        sources = {
          null_ls.builtins.diagnostics.vale.with {
            filetypes = { 'tex', 'markdown' }, -- adjust as needed
          },
          -- null_ls.builtins.diagnostics.chktex.with {
          --   filetypes = { 'tex' },
          --   extra_args = { '-q', '-I0' },
          -- },
        },
        -- Optional: how you want to display the diagnostics
        -- diagnostics_format = '[chktex] #{m} (#{c})',
      }
    end,
  },
}
