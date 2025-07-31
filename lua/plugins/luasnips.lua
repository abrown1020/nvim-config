return {
  'L3MON4D3/LuaSnip',
  event = 'BufReadPre',
  version = 'v2.*', -- use latest stable
  build = 'make install_jsregexp',
  dependencies = {
    'rafamadriz/friendly-snippets',
  },

  config = function()
    local luasnip = require 'luasnip'
    local types = require 'luasnip.util.types'
    local tex_snip_path = vim.fn.stdpath 'config' .. '/lua/snippets/tex'

    -- Load friendly-snippets (VSCode format)
    require('luasnip.loaders.from_vscode').lazy_load()

    -- Lazy load Lua snippets
    require('luasnip.loaders.from_lua').lazy_load {
      -- paths = { tex_snip_path },
      paths = { vim.fn.stdpath 'config' .. '/lua/snippets' },
    }

    -- Optional config
    luasnip.config.set_config {
      history = true,
      updateevents = 'TextChanged,TextChangedI',
      enable_autosnippets = true,
      store_selection_keys = '<Tab>',
      region_check_events = 'InsertEnter',
      delete_check_events = 'InsertLeave',
      ext_opts = {
        [types.choiceNode] = {
          active = { virt_text = { { '● Choice Node Active', 'Orange' } }, hl_mode = 'combine' },
        },
      },
    }

    -- Keymaps
    vim.keymap.set({ 'i', 's' }, '<Tab>', function()
      if luasnip.expand_or_jumpable() then
        vim.schedule(function()
          luasnip.expand_or_jump()
        end)
        return ''
      else
        return '<Tab>'
      end
    end, { expr = true, silent = true })

    vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
      if luasnip.jumpable(-1) then
        vim.schedule(function()
          luasnip.jump(-1)
        end)
        return ''
      else
        return '<S-Tab>'
      end
    end, { expr = true, silent = true })
  end,

  vim.keymap.set({ 'i', 's' }, '<C-l>', function()
    require('luasnip').change_choice(1)
  end),

  vim.keymap.set({ 'i', 's' }, '<C-h>', function()
    require('luasnip').change_choice(-1)
  end),

  vim.keymap.set('n', '<leader>ls', function()
    require('luasnip.loaders.from_lua').lazy_load {
      paths = vim.fn.stdpath 'config' .. '/lua/snippets',
    }
    vim.notify('Snippets reloaded from directory.', vim.log.levels.INFO)
  end, { desc = 'Reload LuaSnip snippets' }),
}
