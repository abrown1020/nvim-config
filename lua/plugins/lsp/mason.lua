return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    -- import mason
    local mason = require 'mason'

    -- enable mason and configure icons
    mason.setup {
      ui = {
        -- backdrop = 100,
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    }

    -- import mason-lspconfig
    local mason_lspconfig = require 'mason-lspconfig'
    mason_lspconfig.setup {
      -- list of LSP servers to install
      ensure_installed = {
        'html',
        'lua_ls',
        -- 'pyright', -- Python LSP
        -- 'texlab', -- LaTeX LSP
        'rust_analyzer', -- Rust LSP
      },

      automatic_installation = true,
      automatic_enable = true,
    }

    -- import mason-tool-installer
    local mason_tool_installer = require 'mason-tool-installer'
    mason_tool_installer.setup {
      ensure_installed = {
        -- Formatters
        -- 'prettier', -- JavaScript/HTML formatter
        'stylua', -- Lua formatter
        'isort', -- Python import sorter
        -- 'black', -- Python formatter
        -- 'tex-fmt', -- Latex formatting
        -- Linters
        'ruff', -- Python linter
      },
    }
  end,
}
