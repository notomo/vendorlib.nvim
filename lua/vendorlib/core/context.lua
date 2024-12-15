local Context = {}

--- @param plugin_name string
--- @param logger table
function Context.new(plugin_name, logger)
  return {
    plugin_name = plugin_name,
    logger = logger,
  }
end

return Context
