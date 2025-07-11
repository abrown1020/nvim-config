return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  config = function()
    require('noice').setup {
      cmdline = {
        enabled = true,
        view = 'cmdline_popup',
        format = {
          cmdline = { pattern = '^:', icon = '', lang = 'vim' },
          search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
          search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
          lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = '', lang = 'lua' },
          help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
          input = { view = 'cmdline_input', icon = '󰥻 ' },
          ['!'] = false,
        },
      },

      messages = {
        enabled = true,
        view_search = 'notify',
        view_error = 'notify',
        view_warn = 'notify',
        view_history = 'messages',
      },

      popupmenu = {
        enabled = true,
        backend = 'nui',
      },

      notify = {
        enabled = true,
        view = 'notify',
      },

      lsp = {
        progress = { enabled = true },
        signature = { enabled = true },
        hover = { enabled = true },
        message = { enabled = true },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },

      views = {
        cmdline_popup = {
          position = {
            row = '90%',
            col = '50%',
          },
          size = {
            width = 60,
            height = 'auto',
          },
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
          },
        },

        split = {
          enter = true,
          win_options = {
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
          },
        },
      },

      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },

      -- highlights = {
      --   -- Gruvbox-compatible UI highlights
      --   NormalFloat = { bg = '#3c3836', fg = '#ebdbb2' },
      --   FloatBorder = { bg = '#3c3836', fg = '#7c6f64' },
      --   NoiceCmdlinePopup = { bg = '#3c3836', fg = '#ebdbb2' },
      --   NoiceCmdlinePopupBorder = { bg = '#3c3836', fg = '#7c6f64' },
      --   NoicePopupmenu = { bg = '#3c3836', fg = '#ebdbb2' },
      --   NoicePopupmenuSelected = { bg = '#fabd2f', fg = '#282828', bold = true },
      --   NoiceVirtualText = { fg = '#928374' },
      -- },
    }

    -- Gruvbox-style border fixes for Noice cmdline popups
    local set_hl = vim.api.nvim_set_hl
    local bg = '#32302f'
    local fg = '#7c6f64'

    local border_groups = {
      'NoiceCmdlinePopupBorderHelp',
      'NoiceCmdlinePopupBorderCmdline',
      'NoiceCmdlinePopupBorderFilter',
      'NoiceCmdlinePopupBorderInput',
      'NoiceCmdlinePopupBorderLua',
      'NoiceCmdlinePopupBorderSearch',
    }
    local content_groups = {
      'NoiceCmdlinePopup',
      'NoiceCmdlinePopupCmdline',
      'NoiceCmdlinePopupLua',
      'NoiceCmdlinePopupHelp',
      'NoiceCmdlinePopupInput',
      'NoiceCmdlinePopupSearch',
    }

    for _, group in ipairs(border_groups) do
      set_hl(0, group, { bg = bg, fg = fg })
    end

    for _, group in ipairs(content_groups) do
      set_hl(0, group, { bg = bg, fg = '#ebdbb2' })
    end

    vim.notify = require 'notify'
  end,
}
