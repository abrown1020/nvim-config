return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- Load before buffers are read
  config = function()
    require('persistence').setup {
      dir = vim.fn.stdpath 'state' .. '/sessions/',
      need = 1,
      options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
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
