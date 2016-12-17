local https = require("ssl.https")
local ltn12 = require("ltn12")
local JSON = require("JSON")

local function makeRequest(id)

  local response = {}
  local url = 'https://thebestory.herokuapp.com/stories/' .. id
  
  local success, code, headers, status = https.request{
    url = url,
    method = "DELETE",
    headers = nil,
    source = nil,
    sink = ltn12.sink.table(response),
  }

  local r = {
    success = success or "false",
    code = code or "0",
    headers = table.concat(headers or {"no headers"}),
    status = status or "0",
    body = table.concat(response or {"no response"}),
  }
  
  return r.code
end

return makeRequest

