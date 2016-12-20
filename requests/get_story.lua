local https = require("ssl.https")
local ltn12 = require("ltn12")
local JSON = require("JSON")

local function makeRequest(after)

  local response = {}
  local url = 'https://thebestory.herokuapp.com/topics/all/unapproved'
  if after then
    url = url .. '?after=' .. after .. "&limit=1"
  else
    url = url .. '?limit=1'
  end
  
  local success, code, headers, status = https.request({
    url = url,
    method = "GET",
    headers = nil,
    source = nil,
    sink = ltn12.sink.table(response),
  })

  local r = {
    success = success or "false",
    code = code or "0",
    headers = table.concat(headers or {"no headers"}),
    status = status or "0",
    body = table.concat(response or {"no response"}),
  }
  
  
  local temp = JSON:decode(r.body)
  return (temp and temp.data and temp.data[1])
  
end


return makeRequest

