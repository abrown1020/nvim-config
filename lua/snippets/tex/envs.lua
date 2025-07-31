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

M = {

  --Display math
  autosnippet(
    { trig = 'dm', name = '\\[...\\]', dscr = 'display math' },
    fmta(
      [[ 
    \[ 
    <>.
    \]
    <>]],
      { i(1), i(0) }
    )
  ),

  -- Inline math
  autosnippet({ trig = 'dk', name = '\\(...\\)', dscr = 'inline math' }, fmta([[\( <> \)<>]], { i(1), i(0) })),

  autosnippet(
    { trig = '-env', dscr = 'autofill environment' },
    fmta(
      [[
      \begin{<>}
          <>
      \end{<>}
    ]],
      {
        i(1),
        i(2),
        rep(1), -- this node repeats insert node i(1)
      }
    )
  ),

  autosnippet(
    { trig = 'ali', name = 'align(|*|ed)', dscr = 'align math' },
    fmta(
      [[ 
    \begin{align<>}
    <>
    .\end{align<>}
    ]],
      { c(1, { t '*', t '', t 'ed', t 'edat' }), i(2), rep(1) }
    ), -- in order of least-most used
    { condition = line_begin, show_condition = tex.show_line_begin }
  ),

  autosnippet(
    { trig = '-pro', dscr = 'New claim and proof environment' },
    fmta(
      [[
      \begin{problem}{<problem_number>}
      {
          <claim>
      }
          <proof>
      \end{problem}
      \newpage
    ]],
      {
        problem_number = i(1, 'problem_number'),
        claim = i(2, 'claim'),
        proof = c(3, {
          t '(Direct)',
          t '(Contradiction)',
          t '(Contrapositive)',
          t '(Induction)',
        }),
      }
    )
  ),

  autosnippet(
    { trig = '-eq', dscr = 'equation' },
    fmta(
      [[
      \begin{equation}<>
          <>.
      \end{equation}<>
      ]],
      {
        c(1, {
          t '',
          fmta([[\label{eq:<>}]], { i(1) }),
        }),
        i(2),
        i(0),
      }
    )
  ),
}

local notes_class_snippets = {

  autosnippet(
    { trig = '-cbox', dscr = 'custom box' },
    fmta(
      [[
      \begin{custombox}[<Title>]{<><label>}
          <>
      \end{custombox}
      <>
      ]],
      {
        Title = i(1, 'Title'),
        c(2, {
          t 'def:',
          t 'dtr:',
          t '',
        }),
        label = i(3, 'label'),
        i(4),
        i(0),
      }
    )
  ),

  autosnippet(
    { trig = '-thm', dscr = 'custom thoerem environment' },
    fmta(
      [[
      \begin{theorem}[<Title>]{thm:<label>}
          <>
      \end{theorem}
      <>
      ]],
      {
        Title = i(1, 'Title'),
        label = i(2, 'label'),
        i(3),
        i(0),
      }
    )
  ),

  autosnippet(
    { trig = '-def', dscr = 'custom definiton environment' },
    fmta(
      [[
      \begin{definition}[<Title>]{thm:<label>}
          <>
      \end{definition}
      <>
      ]],
      {
        Title = i(1, 'Title'),
        label = i(2, 'label'),
        i(3),
        i(0),
      }
    )
  ),
}
vim.list_extend(M, notes_class_snippets)

return M
