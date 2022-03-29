local Context = require("vendorlib.core.context")

local Specification = {}
Specification.__index = Specification

function Specification.from(path)
  vim.validate({ path = { path, "string" } })
  local raw_targets = dofile(path)

  local targets, err = require("vendorlib.core.targets").new(raw_targets)
  if err then
    return nil, err
  end
  local tbl = { _targets = targets }
  return setmetatable(tbl, Specification), nil
end

function Specification.install(self, plugin_name, logger, to)
  local ctx = Context.new(plugin_name, logger)
  return self._targets:install(ctx, to)
end

return Specification
