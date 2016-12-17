local user_manager = { }
local user = { }
user.__index = user
local bot

local use_states = require "menus.controller_menu"
local states = require "users.users_state"

  --Send Text message to user
  function user:send_message(message, reply_to_msg_id, disable_web_prew, disable_notification)
    return bot.sendMessage(self.id, message, "", disable_web_prew, disable_notification, reply_to_msg_id, self.keyboard_markup)
  end
  
  --Get a State of user
  function user:get_state()
    return self.state
  end
  
  function user:send_inline_to_message(message_id, keyboard)
    local response, error_code = bot.editMessageReplyMarkup(self.chat_id, message_id, nil, bot.generateInlineKeyboardMarkup(keyboard))
  end
  
  function user:edit_message(message_id, new_text, keyboard)
    local resp, error_code = bot.editMessageText(self.chat_id, message_id, nil, new_text, nil, nil, bot.generateInlineKeyboardMarkup(keyboard))
  end
  
  --Set a State to user
  function user:set_state(new_state)
    self.state = new_state
    use_states(self.state, self, "/start")
  end

  function user:set_markup(mark_up)
    if mark_up == nil then
      self.keyboard_markup = bot.generateReplyKeyboardHide()
    else
      self.keyboard_markup = bot.generateReplyKeyboardMarkup(mark_up, true)
    end
  end
  
  function user:set_inline_markup(mark_up)
    self.keyboard_markup = bot.generateInlineKeyboardMarkup(mark_up)
  end
  
 
  
  --Block user
  function user:block()
    
  end
  
  
  --Delete user from online
  function user:delete_user()
  end
  
  
  
  --Get a time which user have been in online
  function user:get_online_time()
    return self.online_time
  end
  
  --Reset user online time
  function user:reset_online_time()
    self.online_time = 0
  end
  
  --Add time to user
  function user:add_online_time(dt)
    self.online_time = self.online_time + dt
  end
  
  
  function user:try_state_controller_work(msg, ...)
    use_states(self.state, self, msg, ...)
  end

  
  
  --Set a bot to manager
  function user_manager.set_bot(new_bot)
    bot = new_bot
  end

  
  
  --User constructor
  function user_manager.new(new_user, chat)
    local obj = { }
    obj.name = new_user.username or new_user.first_name
    obj.id = tonumber(new_user.id)
    obj.online_time = 0
    obj.cash = { }
    setmetatable(obj, user)
    obj.state = states.MENU
    obj.chat_id = chat.id
    return obj
  end

  
return user_manager