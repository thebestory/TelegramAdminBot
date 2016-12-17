local updater = { }

--[[updater["add_timing"] = function(dt)
    players_online.update_players(function(user)
        user:add_online_time(dt)
      end)
  end]]


 return function()
   return function(dt) 
  for key, val in pairs(updater) do
    if val(dt) then 
      val = nil
    end
  end
end, function(name, updater_func)
  if updater[name] then
    error("Id already have")
  else 
    updater[name] = updater_func
    return function() updater[name] = nil end
  end
end
end
