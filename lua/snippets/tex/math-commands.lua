local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require 'luasnip.util.events'
local ai = require 'luasnip.nodes.absolute_indexer'
local extras = require 'luasnip.extras'
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local autosnippet = ls.extend_decorator.apply(s, { snippetType = 'autosnippet' })

local tex = require 'snippets.utils.conditions'
local line_begin = require('luasnip.extras.conditions.expand').line_begin

local auto_backslash_snippet = require('snippets.utils.scaffolding').auto_backslash_snippet
local symbol_snippet = require('snippets.utils.scaffolding').symbol_snippet
local single_command_snippet = require('snippets.utils.scaffolding').single_command_snippet
local postfix_snippet = require('snippets.utils.scaffolding').postfix_snippet
local get_visual = require('snippets.utils.scaffolding').get_visual

-- TODO
-- Add quad, quadd, and quad and snippets
-- Fix tt -> text{} error

-- fractions (parentheses case)
local generate_fraction = function(_, snip)
  local stripped = snip.captures[1]
  local depth = 0
  local j = #stripped
  while true do
    local c = stripped:sub(j, j)
    if c == '(' then
      depth = depth + 1
    elseif c == ')' then
      depth = depth - 1
    end
    if depth == 0 then
      break
    end
    j = j - 1
  end
  return sn(
    nil,
    fmta(
      [[
        <>\frac{<>}{<>}
        ]],
      { t(stripped:sub(1, j - 1)), t(stripped:sub(j + 1, -2)), i(1) }
    )
  )
end

M = {
  -- superscripts
  autosnippet({ trig = 'sr', wordTrig = false }, { t '^{2}' }, { condition = tex.in_math, show_condition = tex.in_math }),
  autosnippet({ trig = 'cb', wordTrig = false }, { t '^{3}' }, { condition = tex.in_math, show_condition = tex.in_math }),
  autosnippet({ trig = 'compl', wordTrig = false }, { t '^{c}' }, { condition = tex.in_math, show_condition = tex.in_math }),
  autosnippet({ trig = 'vtr', wordTrig = false }, { t '^{T}' }, { condition = tex.in_math, show_condition = tex.in_math }),
  autosnippet({ trig = 'her', wordTrig = false }, { t '^{h}' }, { condition = tex.in_math, show_condition = tex.in_math }),
  autosnippet({ trig = 'inv', wordTrig = false }, { t '^{-1}' }, { condition = tex.in_math, show_condition = tex.in_math }),
  autosnippet({ trig = 'qan', wordTrig = false }, { t '\\quad \\text{and} \\quad' }, { condition = tex.in_math, show_condition = tex.in_math }),

  -- fractions
  autosnippet(
    { trig = '//', name = 'fraction', dscr = 'fraction (general)' },
    fmta(
      [[
    \frac{<>}{<>}<>
    ]],
      { d(1, get_visual), i(2), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  autosnippet(
    { trig = '((\\d+)|(\\d*)(\\\\)?([A-Za-z]+)((\\^|_)(\\{\\d+\\}|\\d))*)\\/', name = 'fraction', dscr = 'auto fraction 1', trigEngine = 'ecma' },
    fmta(
      [[
    \frac{<>}{<>}<>
    ]],
      { f(function(_, snip)
        return snip.captures[1]
      end), i(1), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
  autosnippet(
    { trig = '(^.*\\))/', name = 'fraction', dscr = 'auto fraction 2', trigEngine = 'ecma' },
    { d(1, generate_fraction) },
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  autosnippet(
    { trig = 'lim', name = 'lim(sup|inf)', dscr = 'lim(sup|inf)' },
    fmta(
      [[ 
    \lim<><><>
    ]],
      { c(1, { t '', t 'sup', t 'inf' }), c(2, { t '', fmta([[_{<> \to <>}]], { i(1, 'n'), i(2, '\\infty') }) }), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  autosnippet(
    { trig = 'sum', name = 'summation', dscr = 'summation' },
    fmta(
      [[
    \sum<> <>
    ]],
      { c(1, { fmta([[_{<>}^{<>}]], { i(1, 'k = 1'), i(2, '\\infty') }), t '' }), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  autosnippet(
    { trig = 'prod', name = 'product', dscr = 'product' },
    fmta(
      [[
    \prod<> <>
    ]],
      { c(1, { fmta([[_{<>}^{<>}]], { i(1, 'i = 0'), i(2, '\\infty') }), t '' }), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  autosnippet(
    { trig = 'cprod', name = 'coproduct', dscr = 'coproduct' },
    fmta(
      [[
    \coprod<> <>
    ]],
      { c(1, { fmta([[_{<>}^{<>}]], { i(1, 'i = 0'), i(2, '\\infty') }), t '' }), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  autosnippet(
    { trig = 'set', name = 'set', dscr = 'set' }, -- overload with set builders notation because analysis and algebra cannot agree on a singular notation
    fmta(
      [[
    \{<>\}<>
    ]],
      { c(1, { r(1, ''), sn(nil, { r(1, ''), t ' \\mid ', i(2) }), sn(nil, { r(1, ''), t ' \\colon ', i(2) }) }), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  autosnippet(
    { trig = 'nnn', name = 'bigcap', dscr = 'bigcap' },
    fmta(
      [[
    \bigcap<> <>
    ]],
      { c(1, { fmta([[_{<>}^{<>}]], { i(1, 'i = 0'), i(2, '\\infty') }), t '' }), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  autosnippet(
    { trig = 'uuu', name = 'bigcup', dscr = 'bigcup' },
    fmta(
      [[
    \bigcup<> <>
    ]],
      { c(1, { fmta([[_{<>}^{<>}]], { i(1, 'i = 0'), i(2, '\\infty') }), t '' }), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  autosnippet(
    { trig = 'bnc', name = 'binomial', dscr = 'binomial (nCR)' },
    fmta(
      [[
    \binom{<>}{<>}<>
    ]],
      { i(1), i(2), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  autosnippet(
    { trig = 'pd', name = 'partial', dscr = 'partial derivative' },
    fmta(
      [[
    \frac{\partial <>}{\partial <>}<>
    ]],
      { i(1), i(2), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  autosnippet(
    { trig = 'cong', name = 'congruence', dscr = 'Congruent modulo n' },
    fmta(
      [[
    \equiv_{<quotient>}<>
    ]],
      { quotient = i(1, 'quotient'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),

  autosnippet(
    { trig = 'EE', name = 'Expectation', dscr = 'Expectation Operator' },
    fmta([[\mathbb{E} <> <>]], {
      c(1, {
        fmta([[\left[ <arg> \right] <>]], { arg = i(1, 'arg'), i(0) }),
        fmta([[\left( <arg> \right) <>]], { arg = i(1, 'arg'), i(0) }),
      }),
      i(0),
    }, { condition = tex.in_math, show_condition = tex.in_math })
  ),

  autosnippet(
    { trig = 'PP', name = 'Probability', dscr = 'Probability Measure' },
    fmta(
      [[
    \mathbb{P}\left( <arg> \right)<>
    ]],
      { arg = i(1, 'arg'), i(0) }
    ),
    { condition = tex.in_math, show_condition = tex.in_math }
  ),
}

-- Auto backslashes
local auto_backslash_specs = {
  'arcsin',
  'sin',
  'arccos',
  'cos',
  'arctan',
  'tan',
  'cot',
  'csc',
  'sec',
  'log',
  'ln',
  'exp',
  'ast',
  'star',
  'perp',
  'sup',
  'inf',
  'det',
  'max',
  'min',
  'argmax',
  'argmin',
  'deg',
  'angle',
  'approx',
  'gcd',
  'var',
  'cov',
}

local auto_backslash_snippets = {}

for _, name in ipairs(auto_backslash_specs) do
  table.insert(
    auto_backslash_snippets,
    autosnippet(
      {
        trig = '(\\?)' .. name,
        wordTrig = false,
        regTrig = true,
        name = '\\' .. name,
        condition = tex.in_math,
      },
      fmta([[<> <> <>]], {
        f(function(_, snip)
          if snip.captures[1] == '\\' then
            return name
          else
            return '\\' .. name
          end
        end),
        c(1, {
          fmt([[\left( {} \right)]], i(1, 'arg')),
          fmt([[\left( {}, {}\right)]], { i(1, 'arg1'), i(2, 'arg2') }),
          fmt([[ {} ]], i(1, 'arg')),
        }),
        i(0),
      })
    )
  )
end
vim.list_extend(M, auto_backslash_snippets)

local root_snippets = {}
local root_specs = {
  'sqrt',
}

for _, name in ipairs(root_specs) do
  table.insert(
    root_snippets,
    autosnippet(
      {
        trig = '(\\?)' .. name,
        wordTrig = false,
        regTrig = true,
        name = '\\' .. name,
        condition = tex.in_math,
      },
      fmta(
        [[
        <> {<>}
      ]],
        {
          f(function(_, snip)
            if snip.captures[1] == '\\' then
              return name
            else
              return '\\' .. name
            end
          end),
          i(1),
        }
      ),
      { condition = tex.in_math }
    )
  )
end
vim.list_extend(M, root_snippets)

local symbol_specs = {
  -- operators
  ['!='] = { context = { name = '!=' }, command = [[\neq]] },
  ['<='] = { context = { name = '≤' }, command = [[\leq]] },
  ['>='] = { context = { name = '≥' }, command = [[\geq]] },
  ['<<'] = { context = { name = '<<' }, command = [[\ll]] },
  ['>>'] = { context = { name = '>>' }, command = [[\gg]] },
  ['~'] = { context = { name = '~' }, command = [[\sim]] },
  ['~='] = { context = { name = '≈' }, command = [[\approx]] },
  ['~-'] = { context = { name = '≃' }, command = [[\simeq]] },
  ['-~'] = { context = { name = '⋍' }, command = [[\backsimeq]] },
  ['-='] = { context = { name = '≡' }, command = [[\equiv]] },
  ['=~'] = { context = { name = '≅' }, command = [[\cong]] },
  [':='] = { context = { name = '≔' }, command = [[\definedas]] },
  ['**'] = { context = { name = '·', priority = 100 }, command = [[\cdot]] },
  xx = { context = { name = '×' }, command = [[\times]] },
  ['!+'] = { context = { name = '⊕' }, command = [[\oplus]] },
  ['!*'] = { context = { name = '⊗' }, command = [[\otimes]] },
  -- sets
  NN = { context = { name = 'ℕ' }, command = [[\mathbb{N}]] },
  iZZ = { context = { name = 'inℤ', priority = 200 }, command = [[\in \mathbb{Z}]] },
  ZZ = { context = { name = 'ℤ', priority = 100 }, command = [[\mathbb{Z}]] },
  iQQ = { context = { name = 'inℚ', priority = 200 }, command = [[\in \mathbb{Q}]] },
  QQ = { context = { name = 'ℚ', priority = 100 }, command = [[\mathbb{Q}]] },
  iRR = { context = { name = 'inℝ', priority = 200 }, command = [[\in \mathbb{R}]] },
  RR = { context = { name = 'ℝ', priority = 100 }, command = [[\mathbb{R}]] },
  CC = { context = { name = 'ℂ' }, command = [[\mathbb{C}]] },
  OO = { context = { name = '∅' }, command = [[\varnothing]] },
  pwr = { context = { name = 'P' }, command = [[\powerset]] },
  cc = { context = { name = '⊂' }, command = [[\subset]] },
  ['!cq'] = { context = { name = '⊆', priority = 200 }, command = [[\not\subseteq]] },
  cq = { context = { name = '⊆', priority = 100 }, command = [[\subseteq]] },
  qq = { context = { name = '⊃' }, command = [[\supset]] },
  qc = { context = { name = '⊇' }, command = [[\supseteq]] },
  ['\\\\\\'] = { context = { name = '⧵' }, command = [[\setminus]] },
  Nn = { context = { name = '∩' }, command = [[\cap]] },
  UU = { context = { name = '∪' }, command = [[\cup]] },
  ['::'] = { context = { name = ':' }, command = [[\colon]] },
  -- quantifiers and logic stuffs
  AA = { context = { name = '∀' }, command = [[\forall]] },
  EX = { context = { name = '∃' }, command = [[\exists]] },
  ['!inn'] = { context = { name = '∉', priority = 200 }, command = [[\not\in]] },
  inn = { context = { name = '∈', priority = 100 }, command = [[\in]] },
  ['!-'] = { context = { name = '¬' }, command = [[\lnot]] },
  VV = { context = { name = '∨' }, command = [[\lor]] },
  WW = { context = { name = '∧' }, command = [[\land]] },
  ['!W'] = { context = { name = '∧' }, command = [[\bigwedge]] },
  ['=>'] = { context = { name = '⇒' }, command = [[\implies]] },
  ['=<'] = { context = { name = '⇐' }, command = [[\impliedby]] },
  iff = { context = { name = '⟺' }, command = [[\iff]] },
  ['-;'] = { context = { name = '→', priority = 250 }, command = [[\to]] },
  ['!>'] = { context = { name = '↦' }, command = [[\mapsto]] },
  ['<-'] = { context = { name = '↦', priority = 250 }, command = [[\gets]] },
  -- differentials
  dp = { context = { name = '⇐' }, command = [[\partial]] },
  -- arrows
  ['-->'] = { context = { name = '⟶', priority = 500 }, command = [[\longrightarrow]] },
  ['<->'] = { context = { name = '↔', priority = 500 }, command = [[\leftrightarrow]] },
  ['2>'] = { context = { name = '⇉', priority = 400 }, command = [[\rightrightarrows]] },
  upar = { context = { name = '↑' }, command = [[\uparrow]] },
  dnar = { context = { name = '↓' }, command = [[\downarrow]] },
  -- etc
  ooo = { context = { name = '∞' }, command = [[\infty]] },
  lll = { context = { name = 'ℓ' }, command = [[\ell]] },
  dag = { context = { name = '†' }, command = [[\dagger]] },
  ['+-'] = { context = { name = '†' }, command = [[\pm]] },
  ['-+'] = { context = { name = '†' }, command = [[\mp]] },
}

local symbol_snippets = {}
for k, v in pairs(symbol_specs) do
  table.insert(
    symbol_snippets,
    symbol_snippet(vim.tbl_deep_extend('keep', { trig = k }, v.context), v.command, { condition = tex.in_math, show_condition = tex.in_math })
  )
end
vim.list_extend(M, symbol_snippets)

local single_command_math_specs = {
  tt = {
    context = {
      name = 'text (math)',
      dscr = 'text in math mode',
    },
    command = [[\text]],
  },
  sbf = {
    context = {
      name = 'symbf',
      dscr = 'bold math text',
    },
    command = [[\symbf]],
  },
  syi = {
    context = {
      name = 'symit',
      dscr = 'italic math text',
    },
    command = [[\symit]],
  },
  udd = {
    context = {
      name = 'underline (math)',
      dscr = 'underlined text in math mode',
    },
    command = [[\underline]],
  },
  conj = {
    context = {
      name = 'conjugate',
      dscr = 'conjugate (overline)',
    },
    command = [[\overline]],
  },
  ['__'] = {
    context = {
      name = 'subscript',
      dscr = 'auto subscript 3',
      wordTrig = false,
    },
    command = [[_]],
  },
  td = {
    context = {
      name = 'superscript',
      dscr = 'auto superscript alt',
      wordTrig = false,
    },
    command = [[^]],
  },
  sbt = {
    context = {
      name = 'substack',
      dscr = 'substack for sums/products',
    },
    command = [[\substack]],
  },
  sq = {
    context = {
      name = 'sqrt',
      dscr = 'sqrt',
    },
    command = [[\sqrt]],
    ext = { choice = true },
  },
  bxd = {
    context = {
      name = 'boxed',
      dscr = 'boxed answer',
    },
    command = [[\boxed]],
  },
}

local superscript_snip = {
  autosnippet({
    trig = '%^',
    regTrig = true,
    wordTrig = false,
    condition = tex.in_math,
  }, fmta([[^{<>}<>]], { i(1), i(0) })),
  autosnippet({
    trig = '_',
    regTrig = true,
    wordTrig = false,
    condition = tex.in_math,
  }, fmta([[_{<>}<>]], { i(1), i(0) })),
}
vim.list_extend(M, superscript_snip)

local single_command_math_snippets = {}
for k, v in pairs(single_command_math_specs) do
  table.insert(
    single_command_math_snippets,
    single_command_snippet(
      vim.tbl_deep_extend('keep', { trig = k, snippetType = 'autosnippet' }, v.context),
      v.command,
      { condition = tex.in_math, show_condition = tex.in_math },
      v.ext or {}
    )
  )
end
vim.list_extend(M, single_command_math_snippets)

local postfix_math_specs = {
  mbb = {
    context = {
      name = 'mathbb',
      dscr = 'math blackboard bold',
    },
    command = {
      pre = [[\mathbb{]],
      post = [[}]],
    },
  },
  mcal = {
    context = {
      name = 'mathcal',
      dscr = 'math calligraphic',
    },
    command = {
      pre = [[\mathcal{]],
      post = [[}]],
    },
  },
  mscr = {
    context = {
      name = 'mathscr',
      dscr = 'math script',
    },
    command = {
      pre = [[\mathscr{]],
      post = [[}]],
    },
  },
  mfr = {
    context = {
      name = 'mathfrak',
      dscr = 'mathfrak',
    },
    command = {
      pre = [[\mathfrak{]],
      post = [[}]],
    },
  },
  hat = {
    context = {
      name = 'hat',
      dscr = 'hat',
    },
    command = {
      pre = [[\hat{]],
      post = [[}]],
    },
  },
  bar = {
    context = {
      name = 'bar',
      dscr = 'bar (overline)',
    },
    command = {
      pre = [[\overline{]],
      post = [[}]],
    },
  },
  tld = {
    context = {
      name = 'tilde',
      priority = 500,
      dscr = 'tilde',
    },
    command = {
      pre = [[\tilde{]],
      post = [[}]],
    },
  },
}

local postfix_math_snippets = {}
for k, v in pairs(postfix_math_specs) do
  table.insert(
    postfix_math_snippets,
    postfix_snippet(
      vim.tbl_deep_extend('keep', { trig = k, snippetType = 'autosnippet' }, v.context),
      v.command,
      { condition = tex.in_math, show_condition = tex.in_math }
    )
  )
end
vim.list_extend(M, postfix_math_snippets)

local matrix_vector_snippets = {

  -- Uppercase Greek letter (LaTeX-style) → \matr{}
  autosnippet({
    trig = '\\([A-Z]+);',
    -- trig = '\\\\(Alpha|Beta|Gamma|Delta|Epsilon|Zeta|Eta|Theta|Iota|Kappa|Lambda|Mu|Nu|Xi|Omicron|Pi|Rho|Sigma|Tau|Upsilon|Phi|Chi|Psi|Omega);',
    condition = tex.in_math,
    regTrig = true,
    wordTrig = false,
    priority = 300,
  }, {
    f(function(_, snip)
      return '\\matr{\\' .. snip.captures[1] .. '}'
    end, {}),
  }),

  autosnippet({
    trig = '\\([a-z]+);',
    -- trig = '\\\\(alpha|beta|gamma|delta|epsilon|zeta|eta|theta|iota|kappa|lambda|mu|nu|xi|omicron|pi|rho|sigma|tau|upsilon|phi|chi|psi|omega);',
    condition = tex.in_math,
    regTrig = true,
    wordTrig = false,
    priority = 200,
  }, {
    f(function(_, snip)
      return '\\gvect{\\' .. snip.captures[1] .. '}'
    end, {}),
  }),

  autosnippet({
    trig = '([a-z]);',
    regTrig = true,
    condition = tex.in_math,
    wordTrig = false,
    priority = 100,
  }, {
    f(function(_, snip)
      return '\\vect{' .. snip.captures[1] .. '}'
    end, {}),
  }),

  -- Uppercase Latin letter → \matr{}
  autosnippet({
    trig = '([A-Z]);',
    regTrig = true,
    condition = tex.in_math,
    wordTrig = false,
    priority = 100,
  }, {
    f(function(_, snip)
      return '\\matr{' .. snip.captures[1] .. '}'
    end, {}),
  }),
}
vim.list_extend(M, matrix_vector_snippets)

return M
