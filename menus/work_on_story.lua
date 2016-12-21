local work_menu = (require "menus.default_menu")("Work on story menu")
local all_states = require "users.users_state"
local work_keyboard = { {'Удалить_историю', 'Изменить_текст_истории', 'Отослать_историю'}, {'Вернуть_историю'} }
local topics = (require "const_lib.constants").topics
local patch_story = require "requests.patch_story"
local delete_story = require "requests.delete_story"


local function get_topics_after(num, page)
  local last_tab = { }
  if page > 1 then
    table.insert(last_tab, { text = "Предыдущие", callback_data = "-1"})
  end
  
  if page < #topics / 6 then
    table.insert(last_tab, { text = "Следующие", callback_data = "-2"})
  end
  
  local tab = {{ },{ }}
  local count = 0
  for key, val in ipairs(topics) do
    if key >= num then
      if (count < 3) then
        table.insert(tab[1], { text = val, callback_data = tostring(key) })
      else
        table.insert(tab[2], { text = val, callback_data = tostring(key) })
      end
      count = count + 1
      if count >= 6 then
        break
      end
    end
  end
  table.insert(tab, last_tab)
  return tab
end


local function change_story_content(story, content)
  story.content = content
end


work_menu:add_command('/start', 
  function(user)
    user:set_markup(work_keyboard)
    user.cash.change = false
    user:send_message(user.cash.story_content.content)
    user:set_inline_markup(get_topics_after(1, 1))
    user.cash.page = 1
    
    local resp, error_code = user:send_message("На данный момент категория: ".. user.cash.story_content.topic.slug)
    user.cash.prev_message_id = resp.result.message_id
    user:set_markup(work_keyboard)
  end)

work_menu:add_command("/default", function(user, ...) 
    if (user.cash.change) then
      local temp = { ... }
      local changed_stroy = table.concat(temp, " ")
      change_story_content(user.cash.story_content, changed_stroy)
      user.cash.change = false
      
      
      user:send_inline_to_message(user.cash.prev_message_id)
      user:send_message(user.cash.story_content.content)
      user:set_inline_markup(get_topics_after((user.cash.page - 1)*6 + 1, user.cash.page))
      local resp, error_code =  user:send_message("На данный момент категория: ".. topics[user.cash.story_content.category])
      user.cash.prev_message_id = resp.result.message_id
      user:set_markup(work_keyboard)
      user:send_message("История успешно изменена.")
    end
  end)

work_menu:add_command('Удалить_историю', 
  function(user, ...)
    delete_story(user.cash.story_content.id)
    user.cash.story_content = nil
    user:send_message("История удалена")
    user:set_state(all_states.WORK)
  end)

work_menu:add_command('Отослать_историю',
  function(user, ...)
    patch_story(user.cash.story_content.id, user.cash.story_content.content, topics[user.cash.story_content.category], true)
    user.cash.story_content = nil
    user:send_message("История отослана")
    user:set_state(all_states.WORK)
  end)


work_menu:add_command('Вернуть_историю', 
  function(user, ...)
    user.cash.story_content = nil
    user:send_message("История возвращена")
    user:set_state(all_states.WORK)
  end)

work_menu:add_command('Изменить_текст_истории', 
  function(user, ...)
    user:set_markup(nil)
    user.cash.change = true
    user:send_message("Отправь следующим сообщением измененый текст истории")
  end)


local function on_update_inline(user, update)
  local switch = tonumber(update.data)
  if (switch == -1) then
    if (user.cash.page > 1) then
      user.cash.page = user.cash.page - 1
      user:send_inline_to_message(update.message.message_id, get_topics_after((user.cash.page - 1)*6 + 1, user.cash.page))
    end
  elseif (switch == -2) then
    if (user.cash.page < #topics / 6) then
      user.cash.page = user.cash.page + 1
      user:send_inline_to_message(update.message.message_id, get_topics_after((user.cash.page - 1)*6 + 1, user.cash.page))
    end
  elseif (topics[switch]) then
    user.cash.story_content.category = switch
    user:edit_message(update.message.message_id, 
                        "На данный момент категория: ".. topics[user.cash.story_content.category],
                        get_topics_after((user.cash.page - 1)*6 + 1, user.cash.page))
    
  end
end

return function () return work_menu, on_update_inline end