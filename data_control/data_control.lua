local admins_file = "files/admins.txt"
local md5 = require "md5"
local M = { }
local admins = { }
local log = require("log.log")()

local function find_free_id()
  local key = 1
  while admins[key] ~= nil do
    key = key + 1
  end
  return key
end

local function check_admins_name(name)
  for key, val in pairs(admins) do
    if (val.name == name) then
      return true
    end
  end  
  return false
end

function M.check_admins_name(name)
  return check_admins_name(name)
end

function M.look_all_admins()
  for line in io.lines(admins_file) do
    print (line)
  end
end

function M.get_all_admins()
  return pairs(admins)
end

function M.find_admin_with_userid(userid)
  userid = tonumber(userid)
  for key, val in pairs(admins) do
    if (val.userid == userid) then
      return val.name
    end
  end
end

local function get_all_admins()
  admins = { }
  for line in io.lines(admins_file) do
    local admin = { }
    for w in string.gmatch(line, '[^%s]+') do
      if not admin.id then
        admin.id = tonumber(w)
      elseif not admin.name then
        admin.name = w
      elseif not admin.password then
        admin.password = w
      elseif not admin.userid then
        admin.userid = tonumber(w)
      else
        admin.last_date = (admin.last_date or w) .. ((admin.last_date and " ".. w) or "")
      end
    end
    admin.last_date = (admin.last_date or "")
    admins[admin.id] = admin
  end
  return admins
end

function M.add_admin(id, name, password, userid) 
  userid = tonumber(userid)
  id = tonumber(id)
  if (not admins[id].generated_code or check_admins_name(name)) then
    return false
  end
  
  admins[id] = {id = id, name = name, password = md5.sumhexa(password), userid = userid, last_date = os.date()}
  local file = io.open (admins_file, "a+")
  file:write("\n"..id .. " " .. name .. " " .. admins[id].password .. " " .. userid .. " ".. admins[id].last_date)
  file:close()
  log.new_admin(id, name)
  return true
end

function M.check_admin(name, password, userid)
    password = md5.sumhexa(password)
    for key, val in pairs(admins) do
      if val.id ~= 1 and val.name == name and val.password == password then
        if userid then
          val.userid = tonumber(userid)
          val.last_date = os.date()
        end
        return val.id
      end
    end
end


local function save_admin()
  local file = io.open (admins_file, "w+")
  for key, val in pairs(admins) do
    if not val.generated_code then
      if key > 1 then
        file:write("\n"..val.id .. " " .. val.name .. " " .. val.password .. " " .. val.userid .. " " .. val.last_date)
      else
        file:write(val.id .. " " .. val.name .. " " .. val.password .. " " .. val.userid .. " " .. val.last_date)
      end
    end
  end
  file:close()
  log.save_data()
end

function M.save_admin()
  save_admin()
end

function M.delete_admin(id)
  if id == 1 then
    return
  end
  for key, val in pairs(admins) do
    if val.id == id then
      log.delete_admin(id, val.name)
      admins[key] = nil
      break
    end
  end
  save_admin()
end

local function get_random_code()
  return math.random(1, 10000)
end

function M.get_permission()
  local key = find_free_id()
  admins[key] = { generated_code = get_random_code(), time = 420 }
  return admins[key].generated_code
end

function M.check_permission(code) 
  if code == nil then
    return
  end
  for key, val in pairs(admins) do
    if admins[key].generated_code == code then
      return key
    end
  end
end

function M.update_permission(dt)
  for key, val in pairs(admins) do
    if (val.generated_code) then
      val.time = val.time - dt
      if val.time < 0 then
        admins[key] = nil
      end
    end
  end
end

function M.save_data_in_update()
  if math.floor(os.clock() % 86400) == 0 then
    save_admin()
  end
end

math.randomseed(os.time())
get_all_admins()

return M