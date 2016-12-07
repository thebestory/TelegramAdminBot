local work_menu = (require "menus.default_menu")("Work menu")
local all_states = require "users.users_state"
local work_keyboard = { {"Новая_история" } , {"Уйти"}}


local function get_story()
  return { content = "hellow world!", category = 1 }
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
    user:set_state(all_states.WORK_ON_STORY)
  end)


return work_menu