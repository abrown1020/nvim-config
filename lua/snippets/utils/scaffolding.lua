-- Basically a list of snippet-generating functions or other dynamics that are used frequently
-- [
-- snip_env + autosnippets
-- ]
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
local conds = require 'luasnip.extras.expand_conditions'
local postfix = require('luasnip.extras.postfix').postfix
local types = require 'luasnip.util.types'
local parse = require('luasnip.util.parser').parse_snippet
local ms = ls.multi_snippet
local autosnippet = ls.extend_decorator.apply(s, { snippetType = 'autosnippet' })

M = {}

-- postfix helper function - generates dynamic node
local generate_postfix_dynamicnode = function(_, parent, _, user_arg1, user_arg2)
  local capture = parent.snippet.env.POSTFIX_MATCH
  if #capture > 0 then
    return sn(
      nil,
      fmta(
        [[
        <><><><>
        ]],
        { t(user_arg1), t(capture), t(user_arg2), i(0) }
      )
    )
  else
    local visual_placeholder = parent.snippet.env.SELECT_RAW
    return sn(
      nil,
      fmta(
        [[
        <><><><>
        ]],
        { t(user_arg1), i(1, visual_placeholder), t(user_arg2), i(0) }
      )
    )
  end
end

-- visual util to add insert node - thanks ejmastnak!
M.get_visual = function(_, parent)
  return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
end

-- Auto backslash - thanks kunzaatko! (ref: https://github.com/kunzaatko/nvim-dots/blob/trunk/lua/snippets/tex/utils/snippet_templates.lua)
M.auto_backslash_snippet = function(context, opts)
  opts = opts or {}
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  context.dscr = context.dscr or (context.trig .. 'with automatic backslash')
  context.name = context.name or context.trig
  context.docstring = context.docstring or ([[\]] .. context.trig)
  -- context.trigEngine = 'ecma'
  -- context.trig = '(?<!\\\\)' .. '(' .. context.trig .. ')'
  return autosnippet(
    context,
    fmta(
      [[
    \<><>
    ]],
      { f(function(_, snip)
        return snip.captures[1]
      end), i(0) }
    ),
    opts
  )
end

-- Auto symbol
M.symbol_snippet = function(context, command, opts)
  opts = opts or {}
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  context.dscr = context.dscr or command
  context.name = context.name or command:gsub([[\]], '')
  context.docstring = context.docstring or (command .. [[{0}]])
  context.wordTrig = context.wordTrig or false
  j, _ = string.find(command, context.trig)
  if j == 2 then -- command always starts with backslash
    context.trigEngine = 'ecma'
    context.trig = '(?<!\\\\)' .. '(' .. context.trig .. ')'
    context.hidden = true
  end
  return autosnippet(context, t(command), opts)
end

-- single command with option
-- M.single_command_snippet = function(context, command, opts, ext)
--   opts = opts or {}
--   if not context.trig then
--     error("context doesn't include a `trig` key which is mandatory", 2)
--   end
--   context.dscr = context.dscr or command
--   context.name = context.name or context.dscr
--   local docstring, offset, cnode, lnode
--   if ext.choice == true then
--     docstring = '[' .. [[(<1>)?]] .. ']' .. [[{]] .. [[<2>]] .. [[}]] .. [[<0>]]
--     offset = 1
--     cnode = c(1, { t '', sn(nil, { t '[', i(1, 'opt'), t ']' }) })
--   else
--     docstring = [[{]] .. [[<1>]] .. [[}]] .. [[<0>]]
--   end
--   if ext.label == true then
--     docstring = [[{]] .. [[<1>]] .. [[}]] .. [[\label{(]] .. ext.short .. [[:<2>)?}]] .. [[<0>]]
--     ext.short = ext.short or command
--     lnode = c(2 + (offset or 0), {
--       t '',
--       sn(
--         nil,
--         fmta(
--           [[
--         \label{<>:<>}
--         ]],
--           { t(ext.short), i(1) }
--         )
--       ),
--     })
--   end
--   context.docstring = context.docstring or (command .. docstring)
--   j, _ = string.find(command, context.trig)
--   if j == 2 then
--     context.trigEngine = 'ecma'
--     context.trig = '(?<!\\\\)' .. '(' .. context.trig .. ')'
--     context.hidden = true
--   end
--   -- stype = ext.stype or s
--   return s(context, fmta(command .. [[<>{<>}<><>]], { cnode or t '', d(1 + (offset or 0), get_visual), (lnode or t ''), i(0) }), opts)
-- end

M.single_command_snippet = function(context, command, opts, ext)
  opts = opts or {}
  ext = ext or {}

  -- 1) Mandatory trigger
  if not context.trig then
    error('single_command_snippet: missing context.trig', 2)
  end

  -- 2) Fill in human-readable defaults
  context.dscr = context.dscr or command
  context.name = context.name or context.dscr

  -- 3) Build an optional choice-node before the braces
  local choice_node = ext.choice
      and c(1, {
        t '', -- empty first choice
        sn(nil, { t '[', i(1, ext.choice_placeholder or 'opt'), t ']' }),
      })
    or t ''

  -- 4) Default get_visual: grabs SELECT_RAW if available, else an empty insert
  local get_visual = ext.get_visual or function(_, snip)
    local raw = snip.env.SELECT_RAW or ''
    return sn(nil, i(1, raw))
  end

  -- 5) Index for dynamic-node: 2 if we have a choice-node, else 1
  local dyn_idx = ext.choice and 2 or 1
  --    always supply a fallback “{1}” so the dynamic node has at least one placeholder
  local dyn_node = d(dyn_idx, get_visual, { 1 })

  -- 6) Optional label-node immediately after the dynamic-node
  local label_node = t ''
  if ext.label then
    local lbl = ext.short or context.trig
    label_node = c(dyn_idx + 1, {
      t '',
      sn(nil, fmta('\\label{<>:<>}', { t(lbl), i(1) })),
    })
  end

  -- 7) Build the actual snippet with fmta:
  --    “<>{<>}<><>” gives us four slots: choice, dynamic, label, and exit
  local fmt_str = command .. [[<>{<>}<><>]]
  local nodes = { choice_node, dyn_node, label_node, i(0) }

  return s(context, fmta(fmt_str, nodes), opts)
end

M.postfix_snippet = function(context, command, opts)
  opts = opts or {}
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  if not context.trig then
    error("context doesn't include a `trig` key which is mandatory", 2)
  end
  context.dscr = context.dscr
  context.name = context.name or context.dscr
  context.docstring = command.pre .. [[(POSTFIX_MATCH|VISUAL|<1>)]] .. command.post
  context.match_pattern = [[[%w%.%_%-%"%']*$]]
  j, _ = string.find(command.pre, context.trig)
  if j == 2 then
    context.trigEngine = 'ecma'
    context.trig = '(?<!\\\\)' .. '(' .. context.trig .. ')'
    context.hidden = true
  end
  return postfix(context, { d(1, generate_postfix_dynamicnode, {}, { user_args = { command.pre, command.post } }) }, opts)
end

return M
