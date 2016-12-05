local data = require "data_control.data_control"


return function(dt)
  data.update_permission(dt)
end