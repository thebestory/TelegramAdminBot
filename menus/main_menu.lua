local main_menu = (require "menus.default_menu")("Main menu")
local my_keyboard = { { "Новенький", "Старенький" } } 
local all_states = require "users.users_state"

main_menu:add_command("/start", 
  function(user, ...) 
    user:set_markup(my_keyboard)
    user:send_message("Привет, котик, ты кто? <3")
  end)

local randoms = { "Я тебя тоже люблю", "Ты прелесть", "Мур", "Мур, мур", "Мур, мур, мур" }

main_menu:add_command("/default", function(user, ...) 
    user:set_markup(my_keyboard)
    user:send_message(randoms[math.random(1, #randoms)]) 
  end)

main_menu:add_command("Новенький", function(user, ...)
    user:set_state(all_states.CREATE_NEW_ADMIN)
  end)

main_menu:add_command("Старенький", function(user, ...)
    user:set_state(all_states.LOGIN)
  end)
    


return main_menu