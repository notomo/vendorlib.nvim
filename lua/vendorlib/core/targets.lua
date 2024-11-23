local VendorTargets = {}
VendorTargets.__index = VendorTargets

--- @param raw_targets string[]
function VendorTargets.new(raw_targets)
  local targets = {}
  local errs = require("vendorlib.vendor.misclib.multi_error").new()
  for _, raw_target in ipairs(raw_targets) do
    local target = require("vendorlib.core.target").new(raw_target)
    if type(target) == "string" then
      local err = target
      errs:add(err)
    else
      table.insert(targets, target)
    end
  end
  local err = errs:error()
  if err then
    return err
  end

  local tbl = { _targets = targets }
  return setmetatable(tbl, VendorTargets)
end

--- @param ctx table
function VendorTargets.install(self, ctx, to)
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
