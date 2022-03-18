local Context = require("vendorlib.core.context")

local Specification = {}
Specification.__index = Specification

function Specification.from(path)
  vim.validate({ path = { path, "string" } })
  local raw_targets = dofile(path)
  local tbl = {
    _targets = require("vendorlib.core.targets").new(raw_targets),
  }
  return setmetatable(tbl, Specification)
end

function Specification.install(self, plugin_name, to)
  local ctx = Context.new(plugin_name)
  return self._targets:install(ctx, to)
end

return Specification
