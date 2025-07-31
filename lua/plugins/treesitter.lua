return {
  'nvim-treesitter/nvim-treesitter',
    event = "BufReadPost", 
  build = ':TSUpdate',
  priority = 500,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
      'lua',
      'vim',
      'vimdoc',
      'python',
      'latex',
      -- 'javascript',
      'json',
      'yaml',
      -- 'html',
      -- 'css',
      'toml',
      'markdown',
      'markdown_inline',
      'regex',
      'gitignore',
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'latex', 'ruby' }, -- latex may need both regex + TS
    },
    indent = {
      enable = true,
      disable = { 'ruby', 'latex' }, -- latex indentation still not reliable
    },
  },
}
