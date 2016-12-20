local data = require "data_control.data_control"

return function(dt)
  data.save_data_in_update()
end
