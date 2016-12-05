local god_menu = (require "menus.default_menu")("God menu")
local all_states = require "users.users_state"
local god_keyboard = { {"Смертная_работа", "Божественная_работа" } , {"Уйти"}}

god_menu:add_command('/start', 
  function(user)
    user:set_markup(god_keyboard)
    user:send_message("Ура! Я по тебе скучала. Думала, что ты забыл про меня :(\nНе бросай меня больше, пожалуйста...")
  end)

god_menu:add_command("/default", function(user, ...) 
    user:set_markup(god_keyboard)
    user:send_message("Я тебя люблю")
  end)

god_menu:add_command("Уйти", function(user, ...) 
    user:set_state(all_states.MENU)
  end)

god_menu:add_command("Смертная_работа", 
  function(user, ...)
    user.cash.acc = {id = 1, name = "alex"}
    user:set_state(all_states.WORK)
  end)

god_menu:add_command("Божественная_работа", 
  function(user, ...)
    user:set_state(all_states.GOD_ADMIN)
  end)

return god_menu