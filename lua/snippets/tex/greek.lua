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

-- Define table of greek letters
local greek_letters = {
  [':a'] = 'alpha',
  [':b'] = 'beta',
  [':g'] = 'gamma',
  [':d'] = 'delta',
  [':e'] = 'varepsilon',
  [':z'] = 'zeta',
  [':h'] = 'eta',
  [':q'] = 'theta',
  [':i'] = 'iota',
  [':k'] = 'kappa',
  [':l'] = 'lambda',
  [':m'] = 'mu',
  [':n'] = 'nu',
  [':x'] = 'xi',
  [':p'] = 'pi',
  [':r'] = 'rho',
  [':s'] = 'sigma',
  [':t'] = 'tau',
  [':u'] = 'upsilon',
  [':f'] = 'phi',
  [':c'] = 'chi',
  [':y'] = 'psi',
  [':w'] = 'omega',

  --:Capital versions
  [':G'] = 'Gamma',
  [':D'] = 'Delta',
  [':Q'] = 'Theta',
  [':L'] = 'Lambda',
  [':X'] = 'Xi',
  [':P'] = 'Pi',
  [':S'] = 'Sigma',
  [':U'] = 'Upsilon',
  [':F'] = 'Phi',
  [':Y'] = 'Psi',
  [':W'] = 'Omega',
}

local greek_snippets = {}

-- Regular Greek Letters
for trig, name in pairs(greek_letters) do
  table.insert(
    greek_snippets,
    autosnippet({
      trig = trig,
      name = name,
      dscr = 'Greek letter ' .. name,
      condition = tex.in_math,
      wordTrig = false,
      -- regTrig = true,
      priority = 100,
    }, t('\\' .. name))
  )
end

-- Bold Greek Letters
for trig, name in pairs(greek_letters) do
  table.insert(
    greek_snippets,
    autosnippet({
      trig = ':' .. trig, -- makes ;;a
      name = 'bold ' .. name,
      dscr = 'Bold Greek letter ' .. name,
      condition = tex.in_math,
      priority = 200,
    }, fmta([[\boldsymbol{\<>}<>]], { t(name), i(1) }))
  )
end

return greek_snippets
