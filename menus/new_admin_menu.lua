local new_menu = (require "menus.default_menu")("New admin")
local my_admins = require "data_control.data_control"
local all_states = require "users.users_state"
local keyboard = { {"Уйти"} } 

local new_str = [[А ты и в правду новенький
Теперь введи свой ник
Но не волнуйся, ты сможешь его изменить в будущем, если тебе не будет нравиться
Будь добр, чтобы он не привышал 20 символов
Мур]]

local new_name = function(name)
  return "Ммм, какое красивое у тебя имя: " .. name .. "\nА теперь введи свой пароль, чтобы мы могли общаться и нам никто не мешал\nТолько не более 20 символов тоже, а то трудно удержать у себя в голове..."
end

local about_new = [[Поздравляю! Теперь ты в наших рядах, и мы сможем с тобой общаться целую вечность (или пока ты не нарушишь мои правила)
Я тебе советую удалить сообщение с паролем, и так делать всегда, потому что бывают злые люди, которые совершают злые поступки
Но ты ведь не такой? Не забывай свой логин и пароль, если ты забудешь, то я буду рассержена на тебя, МУР! 
Но ты можешь обратиться к знающим людям, чтобы восстановиться.]]
              
local fuck_error = [[По не известной мне причине ты не смог зарегестрироваться, я предполагаю, что кто-то зарегестрировался вместо тебя, либо прошло достаточно много времени с момента получения кода.
Пожалуйста, обратись к знающим людям, а то мне будет очень плохо((((((]]

new_menu:add_command("/start", 
  function(user) 
    user.cash.code = nil
    user.cash.id = nil
    user.cash.name = nil
    user.cash.password = nil
    user:set_markup(keyboard)
    user:send_message("Введи свой код, миленький, я жду")
  end)
new_menu:add_command("Уйти", function(user)
    user.cash.code = nil
    user.cash.id = nil
    user.cash.name = nil
    user.cash.password = nil
    user:set_state(all_states.MENU)
  end)
    new_menu:add_command("/default", function(user, ...) 
      if not user.cash.code then
        local code = tonumber(select(1, ...))
        if code == nil then
            user:send_message("Возможно, ты ошибься, попробуй заново\nМур")
            return
        end
        
        local temp = my_admins.check_permission(code)
        if temp then
          user.cash.id = temp
          user.cash.code = code
          user:send_message(new_str)
        else
          user:send_message("Ты ошибься с кодом, иногда такое случается, не переживай и попробуй еще раз <3")
          return
        end
      else
        if not user.cash.name then
          local name = tostring(select(1, ...))
          if name == nil or #name > 20 then
            user:send_message("Ты что-то ввел не так, попробуй заново, милый")
            return
          end
          if (my_admins.check_admins_name(name)) then
            user:send_message("К сожалению, я так уже называю одного котика, попробуй придумать иначе")
            return
          end
          
          user.cash.name = name
          user:send_message(new_name(name))
        elseif not user.cash.password then
          local pass = tostring(select(1, ...))
          if pass == nil or #pass > 20 then
            user:send_message("Ты что-то ввел не так, попробуй заново, милый")
            return
          end
          user.cash.password = pass
          if my_admins.check_permission(user.cash.code) then
            user:send_message(about_new)
            my_admins.add_admin(user.cash.id, user.cash.name, user.cash.password, user.id)
            user.cash.acc = {id = user.cash.id, name = user.cash.name}
            user:set_state(all_states.WORK)
          else
            user:send_message(fuck_error) 
            user:set_state(all_states.MENU)
          end
          user.cash.code = nil
          user.cash.id = nil
          user.cash.name = nil
          user.cash.password = nil
        end
      end
    end)


return new_menu