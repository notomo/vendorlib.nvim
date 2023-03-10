local M = {}

--- @class VendorlibInstallOption
--- @field to (fun(ctx:VendorlibInstallContext,module:VendorlibInstallModuleInfo):string)? returns file path to install the module (default: `lua/{ctx.plugin_name}/vendor/{module.lua_path}`)

--- @class VendorlibInstallContext
--- @field plugin_name string: |vendorlib.install()|'s parameter {plugin_name}

--- @class VendorlibInstallModuleInfo
--- @field file_path string
--- @field lua_path string `/lua/{lua_path}`

--- Install specified libraries.
--- @param plugin_name string: plugin name (used as `lua/{plugin_name}` directory name)
--- @param path string: vendor spec file path
--- @param opts VendorlibInstallOption? |VendorlibInstallOption|
function M.install(plugin_name, path, opts)
  local err = require("vendorlib.command").install(plugin_name, path, opts)
  if err then
    require("vendorlib.vendor.misclib.message").error(err)
  end
end

--- @class VendorlibAddOption
--- @field path string? specification file output path

--- Add modules to specification file.
--- @param targets string[]: module names
--- @param opts VendorlibAddOption? |VendorlibAddOption|
function M.add(targets, opts)
  local err = require("vendorlib.command").add(targets, opts)
  if err then
    require("vendorlib.vendor.misclib.message").error(err)
  end
end

return M
