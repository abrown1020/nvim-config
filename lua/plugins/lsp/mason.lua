return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    -- import mason
    local mason = require 'mason'

    -- import mason-lspconfig
    local mason_lspconfig = require 'mason-lspconfig'

    -- import mason-tool-installer
    local mason_tool_installer = require 'mason-tool-installer'

    -- enable mason and configure icons
    mason.setup {
      ui = {
        backdrop = 100,
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    }

    mason_lspconfig.setup {
      -- list of LSP servers to install
      ensure_installed = {
        'html',
        'lua_ls',
        'pyright', -- Python LSP
        'texlab', -- LaTeX LSP
        -- 'ltex',
      },

      automatic_installation = true,
      automatic_enable = true,
    }

    mason_tool_installer.setup {
      ensure_installed = {
        -- Formatters
        'prettier', -- JavaScript/HTML formatter
        'stylua', -- Lua formatter
        'isort', -- Python import sorter
        'black', -- Python formatter
        'tex-fmt', -- Latex formatting

        -- Linters
        'pylint', -- Python linter
        -- "eslint_d",     -- JS linter
      },
    }
  end,
}
