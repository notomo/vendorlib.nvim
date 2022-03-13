local Context = require("vendorlib.core.context")

local Specification = {}
Specification.__index = Specification

function Specification.from(path)
  vim.validate({ path = { path, "string" } })
  local raw_spec = dofile(path)
  local tbl = {
    _plugin_name = raw_spec.plugin_name,
    _targets = require("vendorlib.core.targets").new(raw_spec.targets),
  }
  return setmetatable(tbl, Specification)
end

function Specification.install(self)
  local ctx = Context.new(self._plugin_name)
  return self._targets:install(ctx)
end

return Specification
