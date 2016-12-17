local god_work = (require "menus.default_menu")("God work")
local all_states = require "users.users_state"
local keyboard = { {"Создай_код_сучка", "Покажи_рабов"}, {"Сохранить_рабов", "Удали_раба", "Статус", "Верни_обратно"}}
local my_admins = require "data_control.data_control"
local log = require("log.log")()
local user_online = require "users.users_online"

god_work:add_command('/start', 
  function(user)
    user:set_markup(keyboard)
    user:send_message("Привет, хозяин :3\nЧего пожелаешь?")
  end)

god_work:add_command("/default", function(user, ...) 
    user:set_markup(keyboard)
    if (user.cash.delete) then
      local args = { ... }
      local id = tonumber(args[1])
      if id then
        my_admins.delete_admin(id)
        user_online.block_user(id)
        user:send_message("Если был раб, то его уже нет <3")
        user.cash.delete = nil
        return
      else
        user:send_message("Что-то пошло не так...")
        return
      end
    end
    
    user:send_message("Я тебя люблю")
  end)

god_work:add_command("Верни_обратно", function(user, ...) 
    user.cash.delete = nil
    user:set_state(all_states.CHOOSE_GOD_ADMIN)
  end)

god_work:add_command("Создай_код_сучка", function(user)
      local code = my_admins.get_permission()
      user:send_message("Как прикажешь, мой повелитель: ")
      user:send_message(code)
    end)
god_work:add_command("Сохранить_рабов", function(user)
      my_admins.save_admin()
      user:send_message("Рабы сохранены, ваше превосходительство, Мур")
  end)

god_work:add_command("Покажи_рабов", function(user)
    local look_rab = "Вот все рабы, которые доступны на данный момент: "
    for key, val in my_admins.get_all_admins() do
        look_rab = look_rab .. "\n"
      if (val.generated_code) then
        look_rab = look_rab .. key ..". code: " .. val.generated_code .. ", time: " .. math.floor(val.time)
      else
        look_rab = look_rab .. key .. ". id: " .. val.id ..", name: " .. val.name .. ", last user id: " .. val.userid ..", last day: "..val.last_date
      end

    end
    user:send_message(look_rab)
  end)

god_work:add_command("Удали_раба", function(user)
  user.cash.delete = true
  user:send_message("Введи id раба, любимый")
end)

god_work:add_command("Статус", function(user)
  log.bot_worked()
end)
return god_work