local VendorTarget = {}
VendorTarget.__index = VendorTarget

function VendorTarget.new(from, to)
  vim.validate({
    from = { from, "table" },
    to = { to, "function", true },
  })

  local modules = require("vendorlib.core.modules").new()
  if from.names then
    modules = modules:add_names(from.names)
  end

  local tbl = {
    _modules = modules,
    _to = to or function(ctx, module)
      return ("lua/%s/vendor/%s.lua"):format(ctx.plugin_name, module.name)
    end,
  }
  return setmetatable(tbl, VendorTarget)
end

function VendorTarget.install(self, ctx)
  vim.validate({ ctx = { ctx, "table" } })
  local errs = {}
  local raw_modules = self._modules:all()
  for _, module in ipairs(raw_modules) do
    local err = module:install(ctx, self._to)
    if err then
      table.insert(errs, err)
    end
  end
  if #errs > 0 then
    return table.concat(errs, "\n")
  end
  return nil
end

return VendorTarget
