local bot
local chat_id = "-1001083753098"
local save_time = os.time()

local log = { }
local function send(message)
  bot.sendMessage(chat_id, message)
end

function log.log(message)
  send(message)
end

function log.new_admin(id, name)
  send("У нас стало на одного котика больше! По приветствуем: " .. name .. "\nЕго порядковый номер: ".. id.. "\nБудь хорошим котиком, делай свою работу хорошо и с душой <3")
end

function log.delete_admin(id, name)
  send("К сожалению, мы вынуждены попрощаться с "..name .. "\nЕго порядковый номер был: "..id.."\nНе грустите, котики, продолжаем идти к нашей цели!")
end

function log.save_data()
  send("Файлы пересохранены")
  log.bot_worked()
end

function log.bot_worked()
  local seconds = os.difftime(os.time(), save_time)
  local minutes = seconds/60
  local hours = minutes/60
  local days = hours/24
  seconds = seconds % 60
  minutes = math.floor(minutes) % 60
  hours = math.floor(hours) % 24
  days = math.floor(days)
  send("Я тут тружусь уже " .. days .. " дней, " .. hours .. " часов, " .. minutes .. " минут, " .. seconds .. " секкунд без отдыха")
end


return function()
  return  log, function(new_bot)
    bot = new_bot
  end
end
