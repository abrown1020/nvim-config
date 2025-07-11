return {
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      require('gruvbox').setup {
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- inverse for search, diff, etc.
        contrast = 'soft', -- 🔸 "hard", "soft", or "" (default)
        dim_inactive = false,
        transparent_mode = false, -- ⛔ solid background
        overrides = {
          -- make all string literals blue
          String = { fg = '#458588' },
          TSString = { fg = '#458588' },

          -- make braces / delimiters red
          Delimiter = { fg = '#fb4934' },
          Bracket = { fg = '#fb4934' },
          TSPunctBracket = { fg = '#fb4934' },
        },
      }

      vim.cmd 'colorscheme gruvbox'
    end,
  },
}
