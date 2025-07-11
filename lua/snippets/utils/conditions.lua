--[
-- LuaSnip Conditions
--]

local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node

local M = {}

M.get_visual = function(_, parent)
  return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
end

-- math / not math zones

function M.in_math()
  return vim.api.nvim_eval 'vimtex#syntax#in_mathzone()' == 1
end

-- comment detection
function M.in_comment()
  return vim.fn['vimtex#syntax#in_comment']() == 1
end

-- document class
function M.in_beamer()
  return vim.b.vimtex['documentclass'] == 'beamer'
end

-- general env function
local function env(name)
  local is_inside = vim.fn['vimtex#env#is_inside'](name)
  return (is_inside[1] > 0 and is_inside[2] > 0)
end

function M.in_preamble()
  return not env 'document'
end

function M.in_text()
  return env 'document' and not M.in_math()
end

function M.in_tikz()
  return env 'tikzpicture'
end

function M.in_bullets()
  return env 'itemize' or env 'enumerate'
end

function M.in_align()
  return env 'align' or env 'align*' or env 'aligned'
end

function M.show_line_begin(line_to_cursor)
  return #line_to_cursor <= 3
end

return M
