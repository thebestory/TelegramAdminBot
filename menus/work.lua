local work_menu = (require "menus.default_menu")("Work menu")
local all_states = require "users.users_state"
local work_keyboard = { {"Новая_история" } , {"Уйти"}}
local consts = require "const_lib.constants"
local get_story_lib = require "requests.get_story"

local function get_story()
  local temp = get_story_lib(consts.last_message_id)
  if temp == nil then
    if consts.last_message_id == nil then
      return nil
    else
      consts.last_message_id = nil
      temp = get_story_lib(consts.last_message_id)
    end
  end
  
  if temp ~= nil then
    consts.last_message_id = temp.id
    temp.topic = { slug = "weird" }
  end
  
  
  return temp
end


work_menu:add_command('/start', 
  function(user)
    user:set_markup(work_keyboard)
    print (user.cash.acc.id .. " is here")
    user:send_message("Привет, "..user.cash.acc.name ..'\nЯ рада тебя видеть :)\nСверим время? Время работать!')
  end)

work_menu:add_command("/default", function(user, ...) 
  end)

work_menu:add_command("Уйти", function(user, ...) 
    user:set_state(all_states.MENU)
    user.cash.acc = nil
  end)

work_menu:add_command("Новая_история", 
  function(user, ...)
    user.cash.story_content = get_story()
    if (user.cash.story_content == nil) then
      user:send_message("К сожалению, пока что нет истории нуждающихся в проверке\nПриходи через некоторое время")
    else
      user:set_state(all_states.WORK_ON_STORY)
    end
  end)


return work_menu