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

local calculus_snippets = {

  autosnippet(
    {
      trig = 'int',
      name = 'Integral',
      wordTrig = false,
      condition = tex.in_math,
    },
    fmta(
      [[ 
      \int <bounds> <integrand> \, d <form> <>
      ]],
      {
        bounds = c(1, {
          t '',
          t '_{\\mathbb{R}}',
          t '_{-\\infty}^{\\infty}',
          fmta([[_{<>}^{<>}]], { i(1), i(2) }),
        }),
        integrand = i(2, 'integrand'),
        form = c(3, {
          t 'x',
          t 't',
          i(1),
        }),
        i(0),
      }
    )
  ),
}

return calculus_snippets
