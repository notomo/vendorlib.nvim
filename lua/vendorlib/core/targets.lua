local VendorTargets = {}
VendorTargets.__index = VendorTargets

function VendorTargets.new(raw_targets)
  vim.validate({ raw_targets = { raw_targets, "table" } })

  local targets = {}
  local errs = require("vendorlib.vendor.misclib.multi_error").new()
  for _, raw_target in ipairs(raw_targets) do
    local target, err = require("vendorlib.core.target").new(raw_target)
    if err then
      errs:add(err)
    else
      table.insert(targets, target)
    end
  end
  local err = errs:error()
  if err then
    return nil, err
  end

  local tbl = { _targets = targets }
  return setmetatable(tbl, VendorTargets), nil
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
