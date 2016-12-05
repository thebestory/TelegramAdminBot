local controller = { }
local all_states = require "users.users_state"


controller[all_states.MENU] = require "menus.main_menu"
controller[all_states.CREATE_NEW_ADMIN] = require "menus.new_admin_menu"
controller[all_states.LOGIN] = require "menus.login"
controller[all_states.GOD_ADMIN] = require "menus.god_admin_work"
controller[all_states.CHOOSE_GOD_ADMIN] = require "menus.choose_god_admin"
controller[all_states.WORK] = require "menus.work"

return function (state, ...)
  if (controller[state]) then
    controller[state]:use(...)
  else
    print("state not supported")
  end
end