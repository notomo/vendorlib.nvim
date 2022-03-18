local M = {}

--- Install specified libraries.
--- @param plugin_name string: plugin name (used as `lua/{plugin_name}` directory name)
--- @param path string: vendor spec file path
--- @param opts table: TODO
function M.install(plugin_name, path, opts)
  return require("vendorlib.command").install(plugin_name, path, opts)
end

return M
