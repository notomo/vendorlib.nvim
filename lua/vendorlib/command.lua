local M = {}

function M.install(plugin_name, path, raw_opts)
  local opts = require("vendorlib.core.option").InstallOption.new(raw_opts)
  return require("vendorlib.core.specification").install(path, plugin_name, opts.logger, opts.to)
end

--- @param raw_targets string[]
--- @param raw_opts table?
function M.add(raw_targets, raw_opts)
  local opts = require("vendorlib.core.option").AddOption.new(raw_opts)
  return require("vendorlib.core.specification").add(raw_targets, opts)
end

return M
