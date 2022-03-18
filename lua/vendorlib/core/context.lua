local Context = {}
Context.__index = Context

function Context.new(plugin_name, logger)
  vim.validate({
    plugin_name = { plugin_name, "string" },
    logger = { logger, "table" },
  })
  local tbl = {
    plugin_name = plugin_name,
    logger = logger,
  }
  return setmetatable(tbl, Context)
end

return Context
