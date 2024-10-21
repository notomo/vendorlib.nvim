local Context = {}
Context.__index = Context

--- @param plugin_name string
--- @param logger table
function Context.new(plugin_name, logger)
  local tbl = {
    plugin_name = plugin_name,
    logger = logger,
  }
  return setmetatable(tbl, Context)
end

return Context
