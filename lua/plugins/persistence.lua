return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- Load before buffers are read
  priority = 500,
  config = function()
    require('persistence').setup {
      dir = vim.fn.stdpath 'state' .. '/sessions/',
      need = 1,
      options = {
        'buffers',
        'tabpages',
        'curdir',
        'winsize',
      },
      -- -- AUTO‑SAVE on every write:
      -- vim.api.nvim_create_autocmd('BufWritePost', {
      --   pattern = '*',
      --   callback = function()
      --     -- this will trigger PersistenceSavePre/SavePost
      --     require('persistence').save()
      --   end,
      -- }),
    }
  end,

  vim.keymap.set('n', '<leader>ss', function()
    require('persistence').save()
  end, { desc = 'Save session' }),
  -- select a session to load
  vim.keymap.set('n', '<leader>sd', function()
    require('persistence').select()
  end),
  -- load the session for the current directory
  vim.keymap.set('n', '<leader>sc', function()
    require('persistence').load()
  end),
}
