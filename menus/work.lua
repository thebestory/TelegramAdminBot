local work_menu = (require "menus.default_menu")("Work menu")
local all_states = require "users.users_state"
local work_keyboard = { {"Работать" } , {"Уйти"}}

work_menu:add_command('/start', 
  function(user)
    user:set_markup(work_keyboard)
    user:send_message("Привет, "..user.cash.acc.name ..'\nЯ рада тебя видеть :)\nСверим время? Время работать!')
  end)

work_menu:add_command("/default", function(user, ...) 
    user:set_markup(work_keyboard)
    user:send_message("Котик, чего же ты хочешь?")
  end)

work_menu:add_command("Уйти", function(user, ...) 
    user:set_state(all_states.MENU)
    user.cash.acc = nil
  end)

work_menu:add_command("Работать", 
  function(user, ...)
    user:send_message("Люблю котиков-работяг <3")
  end)


return work_menu