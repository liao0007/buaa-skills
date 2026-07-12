-- After citeproc: English (Latin-script) entries use "et al.";
-- Chinese entries keep "等". Also normalize page-range ～ → en-dash.
-- Pandoc CSL 1.0 cannot switch et-al terms by item language.

local function has_cjk(s)
  for _, c in utf8.codes(s) do
    if (c >= 0x4E00 and c <= 0x9FFF)
      or (c >= 0x3400 and c <= 0x4DBF)
      or (c >= 0xF900 and c <= 0xFAFF) then
      return true
    end
  end
  return false
end

local function has_latin(s)
  return s:find("[A-Za-z]") ~= nil
end

local function entry_is_english(blocks)
  local text = pandoc.utils.stringify(pandoc.Div(blocks))
  text = text:gsub("^%[%d+%]%s*", "", 1)
  local before = text:match("^(.-)等") or text:match("^(.-)et al%.") or text
  local head = before:sub(1, 120)
  return has_latin(head) and not has_cjk(head)
end

function Div(el)
  if not el.classes:includes("csl-entry") then
    return nil
  end
  local use_etal = entry_is_english(el.content)
  return el:walk({
    Str = function(str)
      local t = str.text
      if use_etal then
        -- citeproc often emits "等." as one token; avoid "et al.."
        t = t:gsub("等%.", "et al.")
        t = t:gsub("等", "et al.")
      end
      t = t:gsub("～", "–")
      if t ~= str.text then
        return pandoc.Str(t)
      end
    end,
  })
end
