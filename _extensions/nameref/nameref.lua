local str = pandoc.utils.stringify
local p = quarto.log.output

function get_header_data(data, numbered)
  local get_headers = {
      -- get the Header text and header id from headers and 
      -- insert them into table `data` passed into `get_header_data`
      Header = function(el)
        local id = el.identifier
        local number = numbered and el.attributes['number'] or ""
        local text = str(el.content):gsub("^[%d.]+ ", "")
        text = number .. " " .. text
        table.insert(data, {id = id, text = text})
      end,
      
      -- get the id and title attribute from pandoc div, so the
      -- generated output has this id and can be referred with.
      Div = function(el)
        if el.attributes["link-id"] then
          local id = el.attributes["link-id"]
          local text = el.attributes["link-title"]
          table.insert(data, {id = id, text = text})
        end
      end
    }
  return get_headers
end


function change_ref(data)
  local change_rawinline = {
    -- change the nameref instance with pandoc.Link
    RawInline = function(el)
      for key, value in pairs(data) do
        if el.text:match("\\nameref{(.*)}") == value.id then
          local target =  "#" .. value.id 
          local link = pandoc.Link(value.text, target)
          return link
        end
      end
    end
  }
  return change_rawinline
end


local function add_div_id(div)
  return {
    -- add id to div with `cell-output-stdout` or 
    -- `cell-output-display`
    Div = function(elem)
      if elem.classes:includes("cell-output-display") 
        or elem.classes:includes("cell-output-stdout") then
          elem.identifier = div.attributes["link-id"]
          return elem
      end
    end
  }
end

function Div(el)
  -- target those div with attribute `link-id`
  if el.attributes["link-id"] then
    -- for markdown syntax (image or table) wrapped withing
    -- div with `link`
    if el.classes:includes('link') then
      el.identifier = el.attributes["link-id"]
    end
    return el:walk(add_div_id(el))
  end
end

function Pandoc(doc)
  local meta = doc.meta
  if meta.nameref then
    local numbered = str(meta.nameref['section-number'])
  end
  local header_data = {}
  -- populate the header_data table 
  doc:walk(get_header_data(header_data, numbered))
  -- generate named link inplaces with `\nameref`
  return doc:walk(change_ref(header_data))
end

