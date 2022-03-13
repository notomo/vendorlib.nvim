local M = {}

--- Install specified libraries.
--- @param path string: vendor spec file path
function M.install(path)
  return require("vendorlib.command").install(path)
end

return M
