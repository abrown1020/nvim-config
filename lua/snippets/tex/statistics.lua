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

local statistics_snippets = {
  -- s(
  --   { trig = 'mvnpdf', name = 'MultivariateNormal' },
  --   fmta(
  --     [[
  --     \frac{ 1 }{ 2\pi ^{ \frac{ <N> }{ 2 } \, \det^{ \tfrac12 } <cov> }
  --     \exp
  --     \left(
  --     - \tfrac12
  --     \left( <data> - <mean> \right)
  --     ^{<tra>} <cov>^{-1}
  --     \left( <data> - <mean> \right)
  --     \right)
  --   ]],
  --     {
  --       N = c(1, { t 'N', t 'n', t 'K', t 'k' }),
  --       cov = c(2, { t '\\gmatr{\\Sigma}', t '\\matr{C}' }),
  --       data = i(3, '\\vect{x}'),
  --       tra = c(4, { t 'T', t 'H' }),
  --       mean = i(5, '\\gvect{\\mu}'),
  --     }
  --   )
  -- ),
  s(
    { trig = 'mvnpdf', name = 'MultivariateNormal' },
    fmta(
      [[
      \frac{ 1 }{ 2\pi ^{ \frac{ <N> }{ 2 } \, \det^{ \tfrac12 } <cov_1> } } \exp \left( - \tfrac12 \left( <data_1> -~ <mean_1> \right) ^{<tra>} <cov_2>^{-1} \left( <data_2> -~ <mean_2> \right)
      \right)
    ]],
      {
        N = c(1, { t 'N', t 'n', t 'k', t 'K' }),
        cov_1 = c(2, { t '\\gmatr{\\Sigma}', t '\\matr{C}' }),
        data_1 = i(3, '\\vect{x}'),
        mean_1 = c(4, { t '\\vect{x}' }),
        tra = c(5, { t 'T', t 'H' }),
        cov_2 = rep(2),
        data_2 = rep(3),
        mean_2 = rep(4),
      }
    )
  ),

  s(
    { trig = 'gaussRV', name = 'Normal Distribution' },
    fmta([[ \mathcal{N}\left( <mean>, <cov> \right) <>]], {
      mean = i(1, mean),
      cov = i(2, cov),
      i(0),
    })
  ),
}

return statistics_snippets
