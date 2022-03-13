local VendorTargets = {}
VendorTargets.__index = VendorTargets

function VendorTargets.new(raw_targets)
  vim.validate({ raw_targets = { raw_targets, "table" } })
  local tbl = {
    _targets = vim.tbl_map(function(raw_target)
      return require("vendorlib.core.target").new(raw_target.from, raw_target.to)
    end, raw_targets),
  }
  return setmetatable(tbl, VendorTargets)
end

function VendorTargets.install(self, ctx)
  vim.validate({ ctx = { ctx, "table" } })

  local errs = {}
  for _, target in ipairs(self._targets) do
    local err = target:install(ctx)
    if err then
      table.insert(errs, err)
    end
  end
  if #errs > 0 then
    return table.concat(errs, "\n")
  end
  return nil
end

return VendorTargets
