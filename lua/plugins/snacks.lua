return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  -- @type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    vim.api.nvim_set_hl(0, 'SnacksNormal', { bg = 'NONE' }),
    cursor = {
      enabled = true,
      animation = 'slide',
    },
    dashboard = {
      preset = {
        pick = nil,
        -- @type snacks.dashboard.Item[]
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = ' ', key = 's', desc = 'Restore a Session', action = ":lua require('persistence').select()" },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
        header = [[
                                                                             
               ████ ██████           █████      ██                     
              ███████████             █████                             
              █████████ ███████████████████ ███   ███████████   
             █████████  ███    █████████████ █████ ██████████████   
            █████████ ██████████ █████████ █████ █████ ████ █████   
          ███████████ ███    ███ █████████ █████ █████ ████ █████  
         ██████  █████████████████████ ████ █████ █████ ████ ██████]],
      },
    },
    explorer = { enabled = false },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true },
      },
    },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 5, total = 50 },
        easing = 'linear',
      },
    },
    animate = {
      cmdline = { enabled = true },
    },
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        diagnostics = false,
        indent = false,
        minimal = true,
      },
    },
    dim = { enabled = true },
    -- highlight_overrides = {
    --   texCmd = { fg = '#d79921', italic = true },
    --   texMathZone = { fg = '#b8bb26' },
    --   texSection = { fg = '#fe8019', bold = true },
    --   texComment = { fg = '#928374', italic = true },
    --   texRefZone = { fg = '#d3869b', italic = true },
    --   texCite = { fg = '#d3869b', italic = true },
    -- },
  },

  keys = {
    {
      '<leader>no',
      function()
        require('snacks').notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
      mode = 'n',
    },
    {
      '<leader>bz',
      function()
        require('snacks').zen()
      end,
      desc = 'zen mode',
      mode = 'n',
    },
  },
}
