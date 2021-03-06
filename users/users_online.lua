local players_manager = { }
local players = { }
local event_broadcast_table = { }
local MAX_SECONDS_ONLINE = 600

  local function delete_user (user)
    if user:get_online_time() < MAX_SECONDS_ONLINE then 
      return false
    else
      user:delete_user()
      return true
    end
  end
  
function players_manager.block_user(id)
  for key, val in pairs(players) do
    if val.cash.acc then
      if val.cash.acc.id == id then
        players[key] = nil
        val:block()
      end
    end
  end
end

function players_manager.is_online(id)
  for key, val in pairs(players) do
    if val.cash.acc then
      if val.cash.acc.id == id then
        return true
      end
    end
  end
  return false
end
  
  
  function players_manager.get_user (id)
    return players[id]
  end
    
  function players_manager.add_user (user)
    players[user.id] = user
  end
  
  function players_manager.update_users(dt)
    for key, val in pairs(players) do
      if not delete_user(val) then
        for key_f, val_f in pairs(event_broadcast_table) do
          val_f(val, dt)
        end
      else 
        players[key] = nil
      end
    end
  end
  
  function players_manager.add_event(id, func)
    if event_broadcast_table[id] then
      error("Id have already placed")
    end
    event_broadcast_table[id] = func
    return function() event_broadcast_table[id] = nil end
  end


  players_manager.add_event("add_timing", function(user, dt) 
      user:add_online_time(dt)
    end)
  
return players_manager