return {

  'lervag/vimtex',
  lazy = false, -- ensure it's always loaded
  -- event = 'BufReadPre',
  init = function()
    vim.opt.conceallevel = 2 -- 1 or 2; 2 hides the replacement char as well
    vim.opt.concealcursor = 'c' -- conceal in Normal & Visual modes

    -- ensure VimTeX’s own conceal isn’t disabled
    vim.g.vimtex_syntax_conceal_disable = 0

    -- configure exactly which elements to conceal
    vim.g.vimtex_syntax_conceal = {
      accents = 1, -- é, ö, etc.
      ligatures = 1, -- -- → —, etc.
      cites = 1, -- \cite{…} → [1]
      fancy = 1, -- \(...\) → (…)
      spacing = 1, -- ~ →
      greek = 1, -- \alpha → α
      math_bounds = 1, -- \lbrace → {
      math_delimiters = 1, -- \( … \)
      math_fracs = 1, -- \frac{a}{b} → a⁄b
      math_super_sub = 1, -- x^2 → x², x_1 → x₁
      math_symbols = 1, -- \le → ≤, etc.
      sections = 0, -- turn on if you want "\section" hidden
      styles = 1, -- \emph → *…*, etc.
    }

    vim.g.vimtex_view_method = 'general'
    vim.g.vimtex_view_general_viewer = [[C:/Users/andbr/AppData/Local/SumatraPDF/SumatraPDF.exe]]
    vim.g.vimtex_view_general_options = [[-reuse-instance -forward-search @tex @line @pdf]]
    vim.g.vimtex_quickfix_mode = 1

    -- -- Compiler settings
    vim.g.vimtex_compiler_method = 'latexmk'
    -- vim.g.vimtex_compiler_method = 'generic'
    -- vim.g.vimtex_compiler_generic = {
    -- command = [[latexmk -c -outdir=build; latexmk -pdf -interaction=nonstopmode -file-line-error -synctex=1 -shell-escape -outdir=build %:p]],
    -- }
    vim.g.vimtex_compiler_latexmk = {
      aux_dir = 'build',
      out_dir = 'build',
      executable = 'latexmk',
    }
    -- }
    -- }
  end,
}
