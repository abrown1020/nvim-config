-- lua/core/colors.lua
local M = {}

-- Raw color definitions
local colors = {
  seasalt = '#FAFAFA',
  cosmic_latte = '#F7F3E3',
  paynes_gray = '#99AFC2',
  magnolia = '#EDE6EF',
  light_coral = '#EC8583',
  rosy_brown = '#CEAAA1',
  -- eerie_black = '#191919',
  night = '#0E0E0E',
  tea_green = '#BEDEBA',
  bittersweet_shimmer = '#C34143',
  rose_quartz = '#AA9AAC',
  ecru = '#DEBF7C',
  periwinkle = '#C6BCF1',
  uranian_blue = '#C2DEFF',
  onyx = '#454545',
  wisteria = '#B8ABED',
  thistle = '#D2C1D7',
}

-- UI role mapping
local palette = {
  -- backgrounds
  -- bg = colors.night,
  bg = 'NONE',
  bg_float = colors.eerie_black,
  bg_popup = colors.onyx,
  bg_sidebar = colors.eerie_black,
  bg_search = '#5F5958',
  bg_status = '#34383C',
  bg_diff_add = '#2B3328',
  bg_diff_chg = '#262636',
  bg_diff_del = '#42242B',
  bg_diff_txt = '#49443C',

  -- foregrounds
  fg = colors.seasalt,
  fg_dim = colors.onyx,
  fg_comment = colors.onyx,
  -- fg_const = colors.wisteria,
  fg_const = colors.uranian_blue,
  fg_function = colors.rosy_brown,
  fg_ident = colors.thistle,
  fg_op = colors.ecru,
  fg_dir = colors.seasalt,
  fg_diag_ok = colors.tea_green,
  fg_diag_info = colors.cosmic_latte,
  fg_error = colors.bittersweet_shimmer,
  fg_warning = '#FFEDEB',
  fg_special = colors.periwinkle,
  fg_specialk = '#676767',
  fg_question = '#9B8D7F',
  fg_string = colors.periwinkle,

  -- scrollbars
  scrollbar = '#918988',
  scrollbar_sel = '#BFBBAA',
}

-- Highlight definitions
M.highlights = {
  Normal = { fg = palette.fg, bg = palette.bg },
  NormalNC = { fg = palette.fg_dim, bg = palette.bg },
  NormalFloat = { fg = palette.fg, bg = palette.bg_float },
  StatusLine = { fg = palette.fg_const, bg = palette.bg_status },
  Pmenu = { fg = palette.scrollbar, bg = palette.bg_popup },
  PmenuSel = { fg = palette.scrollbar_sel, bg = palette.bg_popup },
  PmenuSbar = { fg = palette.scrollbar, bg = palette.bg_sidebar },
  PmenuThumb = { fg = palette.scrollbar, bg = palette.bg_sidebar, reverse = true },

  Comment = { fg = palette.fg_comment, italic = true },
  TSComment = { fg = palette.fg_comment, italic = true },
  Conceal = { bg = palette.bg_sidebar },
  Constant = { fg = palette.fg_const },
  DiffAdd = { fg = '#FFFEDB', bg = palette.bg_diff_add },
  DiffChange = { fg = '#FFFEDB', bg = palette.bg_diff_chg },
  DiffDelete = { fg = palette.fg_error, bg = palette.bg_diff_del },
  DiffText = { fg = '#FFFEDB', bg = palette.bg_diff_txt },
  Directory = { fg = palette.fg_dir },
  Error = { fg = palette.fg_error },
  ErrorMsg = { fg = '#FFFEDB' },
  Function = { fg = palette.fg_function, bold = true },
  Identifier = { fg = palette.fg_ident },
  LineNr = { fg = '#6D6D6D', bg = palette.bg },
  CursorLineNr = { fg = palette.fg, bg = palette.bg },
  LineNrAbove = { fg = palette.fg_dim, bg = palette.bg },
  LineNrBelow = { fg = palette.fg_dim, bg = palette.bg },
  MatchParen = { fg = colors.bittersweet_shimmer },
  MoreMsg = { fg = palette.fg_op },
  ModeMsg = { fg = palette.fg_op },
  NonText = { fg = '#303030' },
  Operator = { fg = palette.fg_op },
  PreProc = { fg = palette.fg_ident },
  Question = { fg = palette.fg_question },
  QuickFixLine = { bg = palette.bg_popup },
  Search = { bg = palette.bg_search },
  Special = { fg = palette.fg_const },
  SpecialChar = { fg = palette.fg_special },
  SpecialKey = { fg = palette.fg_specialk },
  Statement = { fg = palette.fg_const },
  Winbar = { fg = palette.fg, bg = palette.bg },
  WinbarNC = { fg = palette.fg, bg = palette.bg },

  -- Semantics
  String = { fg = palette.fg_string },

  -- Diagnostics
  DiagnosticOk = { fg = palette.fg_diag_ok },
  DiagnosticError = { fg = palette.fg_error },
  DiagnosticInfo = { fg = palette.fg_diag_info },

  -- Telescope
  TelescopeNormal = { fg = palette.fg, bg = palette.bg_float },
  TelescopeBorder = { fg = palette.fg, bg = palette.bg_float },
  TelescopePromptBorder = { fg = palette.fg, bg = palette.bg_float },
  TelescopePromptNormal = { fg = palette.fg, bg = palette.bg_float },
  TelescopePromptPrefix = { fg = palette.fg_ident, bg = palette.bg_float },
  TelescopeSelection = { fg = palette.fg_const, bg = palette.bg_popup },
  TelescopeSelectionCaret = { fg = palette.fg_ident },

  -- Snacks
  SnacksDashboardIcon = { fg = colors.fg, bg = palette.bg_float },
  SnacksDashboardDir = { fg = palette.fg, bg = palette.bg_float },
  SnacksDashboardDesc = { fg = palette.fg, bg = palette.bg_float },
  SnacksDashboardKey = { fg = palette.fg, bg = palette.bg_float },

  -- Notify
  NotifyERRORTitle = { fg = palette.fg_error, bg = palette.bg_float },
  NotifyERRORBody = { fg = palette.fg_error, bg = palette.bg },

  -- TreeSitter
  ['@variable'] = { fg = palette.cosmic_latte }, -- example using your palette
  ['@variable.builtin'] = { fg = palette.fg_special, italic = true },
  ['@variable.parameter.builtin'] = { fg = palette.fg_specialk },
}

-- Apply highlights to Neovim
function M.apply()
  for group, opts in pairs(M.highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

-- Export both for external access
M.palette = palette
M.colors = colors

return M
