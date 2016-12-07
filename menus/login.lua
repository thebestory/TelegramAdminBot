local login = (require "menus.default_menu")("Login menu")
local my_admins = require "data_control.data_control"
local all_states = require "users.users_state"
local keyboard = { {"Уйти"} } 
local keyboard_again = { {"Под_новым", "Под_старым"}, {"Уйти"}}
local const = require "const_lib.constants"
local user_online = require "users.users_online"

login:add_command("/start", 
  function(user) 
    local temp = my_admins.find_admin_with_userid(user.id)
    if (temp) then
      user:set_markup(keyboard_again)
      user:send_message("Ага, кажется я тебя уже видела\nХочешь остаться тем же человеком? Или тебе нужно зайти под новым именем?")
      user.cash.again = true
      user.cash.name = temp
    else
      user:set_markup(keyboard)
      user.cash.again = nil
      user.cash.name = nil
      user:send_message("Как тебя зовут? Прости, не припомню тебя...")
    end
  end)

login:add_command("Уйти", 
  function(user)
    user.cash.again = nil
    user.cash.name = nil
    user:set_state(all_states.MENU)
  end)

login:add_command("Под_новым", 
  function(user)
    user:set_markup(keyboard)
    user:send_message("Тогда скажи, как я могу к тебе обращаться в этот раз?")
    user.cash.again = nil
    user.cash.name = nil
  end)

login:add_command("Под_старым",
  function(user)
    if (user.id == const.super_admin_id) then
      user:set_state(all_states.CHOOSE_GOD_ADMIN)
      return
    end
    user:set_markup(keyboard)
    user:send_message("Тогда я попрошу тебя ввести пароль")
    user.cash.again = nil
  end)

login:add_command("/default", function(user, ...) 
    if user.cash.again then
      user:send_message("Ты делаешь что-то не так :(")
    end
    
    if not user.cash.name then
      local name = tostring(select(1, ...))
      if name == nil or #name > 20 then
        user:send_message("Прости, но я уверена, что не знаю таких имен...")
        return
      end
      
      user.cash.name = name
      user:send_message("Так-так-так, а теперь попробуй ввести пароль")
    else 
      local pass = tostring(select(1, ...))
      if pass == nil or #pass > 20 then
        user:send_message("Такой пароль я бы точно не запомнила...")
      end
      local temp = my_admins.check_admin(user.cash.name, pass, user.id)
      if (temp) then
        if (user_online.is_online(temp)) then
          user:send_message("Прости, но ты уже в онлайне. Если это не так, то сочно обратись к знающим людям")
        else
          user.cash.acc = {id = temp, name = user.cash.name}
          user:set_state(all_states.WORK)
        end
      else
        user:send_message("Ты не прошел проверку\nПрости, но мама меня учила не делиться секретами с незнакомыми людьми\nТы, конечно, можешь попробовать заново")
        user.cash.name = my_admins.find_admin_with_userid(user.id)
        if (user.cash.name) then
          user:send_message("И все же я уверена, что знаю тебя\nПопробуй ввести пароль еще раз")
        else
          user:send_message("Так все таки, как мне к тебе обращаться?")
        end
      end
    end
  end)

return login