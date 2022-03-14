local ShowError = require("vendorlib.vendor.error_handler").for_show_error()

function ShowError.install(plugin_name, path)
  local spec = require("vendorlib.core.specification").from(path)
  return spec:install(plugin_name)
end

return ShowError:methods()
