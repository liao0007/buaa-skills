-- Inject longtable continuation captions that Pandoc omits.
-- Pandoc's LaTeX writer repeats column headers in \endhead but does not emit
-- \caption[]{…（续）}, so page 2+ lack "表 x.y 题注（续）".
-- Run after full-width-tables.lua so colspec widths are preserved.

local function latex_escape(text)
  local replacements = {
    ["\\"] = "\\textbackslash{}",
    ["{"] = "\\{",
    ["}"] = "\\}",
    ["#"] = "\\#",
    ["%"] = "\\%",
    ["$"] = "\\$",
    ["&"] = "\\&",
    ["_"] = "\\_",
    ["^"] = "\\textasciicircum{}",
    ["~"] = "\\textasciitilde{}",
  }
  return (text:gsub("[\\{}#%%$&_^~]", replacements))
end

function Table(tbl)
  local caption = pandoc.utils.stringify(tbl.caption and tbl.caption.long or {})
  if caption == "" then
    return tbl
  end

  local latex = pandoc.write(pandoc.Pandoc({ tbl }), "latex")
  local continued = latex_escape(caption) .. "（续）"

  -- Insert continuation caption between \endfirsthead and the repeated header rule.
  local updated, count = latex:gsub(
    "(\\endfirsthead%s*)(\\toprule)",
    "%1\\caption[]{" .. continued .. "}\\tabularnewline\n%2",
    1
  )

  if count == 0 then
    return tbl
  end

  return pandoc.RawBlock("latex", updated)
end
