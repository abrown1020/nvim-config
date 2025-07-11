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

local font_snippets = {
  -- Math fonts
  autosnippet({
    trig = 'bf',
    name = '\\mathbf',
    dscr = 'bold face text',
    condition = tex.in_math,
  }, fmta([[ \mathbf{<arg>}<exit> ]], { arg = i(1, 'arg'), exit = i(0) })),

  -- Text fonts
  autosnippet({
    trig = '\\it',
    name = 'textit',
    dscr = 'italic text',
  }, fmta([[ \textit{<arg>}<exit> ]], { arg = i(1, 'arg'), exit = i(0) })),

  autosnippet(
    {
      trig = '([A-Za-z]),,',
      regTrig = true,
      name = 'mathcal',
      dscr = 'caligraphic text',
      condition = tex.in_math,
    },
    fmta([[\mathcal{<>} <>]], { f(function(_, snip)
      return snip.captures[1]
    end), i(0) })
  ),
}

return font_snippets
