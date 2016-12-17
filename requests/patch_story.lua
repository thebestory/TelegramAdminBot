local https = require("ssl.https")
local ltn12 = require("ltn12")
local JSON = require("JSON")
local encode = require("multipart.multipart-post").encode

local function makeRequest(id, content, topic, is_approved)

  local response = {}
  local url = 'https://thebestory.herokuapp.com/stories/' .. id
  local str = JSON:encode({content = content, topic = topic, is_approved = is_approved})
  
  local temp = {
    url = url,
    method = "PATCH",
    headers = {
      ["Content-Type"] =  "application/json",
    	["Content-Length"] = string.len(str)
    },
    source = ltn12.source.string(str),
    sink = ltn12.sink.table(response)
  }

  local success, code, headers, status = https.request(temp)

  local r = {
    success = success or "false",
    code = code or "0",
    headers = table.concat(headers or {"no headers"}),
    status = status or "0",
    body = table.concat(response or {"no response"}),
  }
  
  return r
  
end


return makeRequest
