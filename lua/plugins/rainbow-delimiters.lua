-- lua/plugins/rainbow-delimiters.lua
return {
  {
    'HiPhish/rainbow-delimiters.nvim',
    enabled = false,
    event = 'BufReadPre',
    dependencies = { 'nvim-treesitter' },
    config = function()
      --─── 1) Core rainbow‑delimiters settings ───────────────────────────────────
      vim.g.rainbow_delimiters = {
        -- use the global strategy for all filetypes
        strategy = {
          [''] = 'rainbow-delimiters.strategy.global',
        },
        -- choose the correct query for default vs LaTeX
        query = {
          [''] = 'rainbow-delimiters',
          latex = 'rainbow-blocks', -- supports \left … \right & \begin…\end
        },
        -- priority controls match order—raise for LaTeX if needed
        priority = {
          [''] = 110,
          latex = 210,
        },
        -- highlight groups by depth
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
        -- only enable in these languages (omit to enable everywhere)
        whitelist = { 'lua', 'vim', 'python', 'latex', 'javascript' },
      }

      --─── 2) Link groups to Catppuccin palette ──────────────────────────────────
      local cp = require('catppuccin.palettes').get_palette()
      local function link(name, color_key)
        vim.api.nvim_set_hl(0, name, { fg = cp[color_key], bg = 'NONE' })
      end

      link('RainbowDelimiterRed', 'red')
      link('RainbowDelimiterYellow', 'yellow')
      link('RainbowDelimiterBlue', 'blue')
      link('RainbowDelimiterOrange', 'orange')
      link('RainbowDelimiterGreen', 'green')
      link('RainbowDelimiterViolet', 'mauve')
      link('RainbowDelimiterCyan', 'teal')
    end,
  },
}
