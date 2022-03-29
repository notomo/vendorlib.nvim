local VendorTargets = {}
VendorTargets.__index = VendorTargets

function VendorTargets.new(raw_targets)
  vim.validate({ raw_targets = { raw_targets, "table" } })
  local tbl = {
    _targets = vim.tbl_map(function(raw_target)
      return require("vendorlib.core.target").new(raw_target)
    end, raw_targets),
  }
  return setmetatable(tbl, VendorTargets)
end

function VendorTargets.install(self, ctx, to)
  vim.validate({ ctx = { ctx, "table" } })
  local errs = require("vendorlib.vendor.misclib.multi_error").new()
  for _, target in ipairs(self._targets) do
    local err = target:install(ctx, to)
    if err then
      errs:add(err)
    end
  end
  return errs:error()
end

return VendorTargets
