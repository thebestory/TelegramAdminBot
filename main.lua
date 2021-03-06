--[[

main method.

Copyright (C) 2016 @TheBestory

]]

-- pass token as command line argument or insert it into code
local consts = require "const_lib.constants"
local token = arg[1] or consts.bot_token


-- create and configure new bot with set token
local bot, extension = require("lua-bot-api").configure(token)
local temp, log = require("log.log")()
log(bot)

temp.log("Я включен")

local users_manager = require "users.user"
users_manager.set_bot(bot)
local users_online = require "users.users_online"

local updater, add_to_me = require("updater.updater")()
add_to_me("update_code", require "updater.updater_code")
add_to_me("update_save_admins", require "updater.save_data_every_day")


local temp2, temp = require ("menus.work_on_story")()
function extension.onCallbackQueryReceive(update) 
  user = users_online.get_user(update.from.id)
  if user then
    temp(user, update)
  end
end


extension.onTextReceive = function (msg)
  local arguments = { }
  local command
  local user = users_online.get_user(msg.from.id)
  
  if not user then
    user = users_manager.new(msg.from, msg.chat)
    users_online.add_user(user)
  else
    user:reset_online_time()
  end
  
  for w in string.gmatch(msg.text, '[^%s]+') do
    if not command then
      command = w
    else
      table.insert(arguments, w)
    end
  end
  
  user:try_state_controller_work(command, unpack(arguments))
end

extension.run(updater)
