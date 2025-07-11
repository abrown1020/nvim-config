return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-telescope/telescope-file-browser.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    local builtin = require 'telescope.builtin'
    local action_state = require 'telescope.actions.state'
    local actions = require 'telescope.actions'
    local telescope = require 'telescope'

    telescope.setup {
      defaults = {
        mappings = {
          i = {
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-l>'] = actions.select_default,
            ['<C-d>'] = actions.delete_buffer,
          },
        },
      },
      path_display = { 'tail' },
      -- layout_strategy = 'horizontal',
      -- layout_config = {
      --   prompt_position = 'top',
      --   preview_width = 0.6, -- % of total width
      --   width = 0.9,
      --   height = 0.8,
      -- },
      -- previewer = true,
      pickers = {
        buffers = {
          path_display = { 'tail' },
          sort_mru = true,
          ignore_current_buffer = false,
          mappings = {
            i = {
              ['<C-d>'] = actions.delete_buffer,
            },
          },
        },
        find_files = {
          path_display = { 'smart' },
          file_ignore_patterns = { 'node_modules', '%.git', '%.venv' },
          hidden = true,
        },
        live_grep = {
          file_ignore_patterns = { 'node_modules', '%.git', '%.venv' },
          additional_args = function(_)
            return { '--hidden' }
          end,
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown {
            winblend = 10,
            borderchars = {
              prompt = { '─', ' ', ' ', ' ', '─', '─', ' ', ' ' },
              results = { ' ' },
              preview = { ' ' },
            },
            previewer = true,
          },
        },
        ['file_browser'] = {
          hijack_netrw = true,
          grouped = true,
          previewer = true,
          hidden = true,
          initial_mode = 'normal',
          sorting_strategy = 'ascending',
          layout_config = {
            height = 40,
            width = 0.9,
            preview_width = 0.6, -- preview on the right
            prompt_position = 'top',
          },
        },
      },
    }

    -- Load extensions
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
    pcall(telescope.load_extension, 'file_browser')

    -- Keymaps
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = true,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- 📁 File browser mappings
    vim.keymap.set('n', '<leader>E', '<cmd>Telescope file_browser<CR>', { desc = '[F]ile [B]rowser (cwd)' })
    vim.keymap.set('n', '<leader>e', function()
      require('telescope').extensions.file_browser.file_browser {
        path = vim.fn.expand '%:p:h',
        select_buffer = true,
      }
    end, { desc = '[F]ile browser (buffer dir)' })
  end,
}
