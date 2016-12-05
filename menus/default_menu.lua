return function (name)
  local obj = {name = name or "", funcs = { } }
  
  function obj:add_command(name, func) 
    self.funcs[name] = func
  end
  
  function obj:use(user, name, ...)
    if (self.funcs[name]) then
      self.funcs[name](user, ...)
    else
      self.funcs['/default'](user, name, ...)
    end
  end
  
  return obj
end
