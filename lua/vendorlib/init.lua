local M = {}

--- Install specified libraries.
--- @param plugin_name string: plugin name (used as `lua/{plugin_name}` directory name)
--- @param path string: vendor spec file path
--- @param opts table: TODO
function M.install(plugin_name, path, opts)
  local err = require("vendorlib.command").install(plugin_name, path, opts)
  if err then
    error("[vendorlib] " .. err, 0)
  end
end

--- Add modules to specification file.
--- @param targets string[]: module names
--- @param opts table: TODO
function M.add(targets, opts)
  local err = require("vendorlib.command").add(targets, opts)
  if err then
    error("[vendorlib] " .. err, 0)
  end
end

return M
