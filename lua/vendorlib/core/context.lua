local Context = {}
Context.__index = Context

function Context.new(plugin_name)
  vim.validate({ plugin_name = { plugin_name, "string" } })
  local tbl = { plugin_name = plugin_name }
  return setmetatable(tbl, Context)
end

return Context
