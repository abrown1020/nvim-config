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

local misc_snippets = {
  autosnippet(
    {
      trig = 'eref',
      name = '\\eqref{}',
      dscr = 'equation reference',
    },
    fmta(
      [[
     \eqref{eq:<>}
      ]],
      { i(1, 'reference') }
    )
  ),
  -- TODO make these a loop
  autosnippet(
    {
      trig = 'sec',
      name = '\\section{}',
      dscr = 'section',
      condition = line_begin,
    },
    fmta(
      [[
      \section{<Title>}<> 
      <>
      ]],
      {
        Title = i(1, 'Title'),
        c(2, {
          t '',
          fmta([[\label{sec:<>}]], { i(1) }),
        }),
        i(0),
      }
    )
  ),
  autosnippet(
    {
      trig = 'ssub',
      name = '\\subsubsection{}',
      dscr = 'subsubsection',
      priority = 200,
    },
    fmta(
      [[
      \subsubsection{<Title>}<> 
      <>
      ]],
      {
        Title = i(1, 'Title'),
        c(2, {
          t '',
          fmta([[\label{sec:<>}]], { i(1) }),
        }),
        i(0),
      }
    )
  ),
  autosnippet(
    {
      trig = 'sub',
      name = '\\subsection{}',
      dscr = 'subsection',
      priority = 100,
    },
    fmta(
      [[
      \subsection{<Title>}<> 
      <>
      ]],
      {
        Title = i(1, 'Title'),
        c(1, {
          t '',
          fmta([[\label{sec:<>}]], { i(1) }),
        }),
        i(0),
      }
    )
  ),
}

return misc_snippets
