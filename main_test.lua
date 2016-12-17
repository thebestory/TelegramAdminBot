local bot, extension = require("lua-bot-api").configure("279009282:AAEVJVs-4Px8AGLqD_3yI6Od_Va0MLma7Ng")
local user_manager = require("Player.Player")
user_manager.set_bot(bot)
local players_online = require("Player.playersonline")
local update_func, add_to_update_func = require("updater.updater")
local command_controller = require("controllers.global_controller")
command_controller.set_bot(bot)

-- override onMessageReceive function so it does what we want
extension.onTextReceive = function (msg)
  local pl = players_online.get_player(msg.from.id)
  local arguments = { }
  local command
  for w in string.gmatch(msg.text, '[^%s]+') do
    if not command then
      command = w
    else
      table.insert(arguments, w)
    end
  end
  
  if command_controller[command] then
    command_controller[command](pl, arguments)
  elseif not pl:try_state_controller_work(command, arguments) and not pl:try_tile_controller_work(command, arguments) then
    command_controller["/unknown_command"](pl, arguments)
  end
end

extension.onUpdateReceive = function(update_m)
  local pl = players_online.get_player(update_m.message.from.id)
  if not pl then
    pl = user_manager:new(update_m.message.from)
    players_online.add_player(pl)
  end
  pl:reset_online_time()
end


extension.run(update_func)
