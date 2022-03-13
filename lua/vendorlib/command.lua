local ShowError = require("vendorlib.vendor.error_handler").for_show_error()

function ShowError.install(path)
  local spec = require("vendorlib.core.specification").from(path)
  return spec:install()
end

return ShowError:methods()
