--url: https://thebestory.herokuapp.com/topics/all/unapproved

local function makeRequest(method, request_body)

  local response = {}
  local body, boundary = encode(request_body)

  local success, code, headers, status = https.request{
    url = "https://api.telegram.org/bot" .. M.token .. "/" .. method,
    method = "POST",
    headers = {
      ["Content-Type"] =  "multipart/form-data; boundary=" .. boundary,
    	["Content-Length"] = string.len(body),
    },
    source = ltn12.source.string(body),
    sink = ltn12.sink.table(response),
  }

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