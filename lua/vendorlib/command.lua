local ShowError = require("vendorlib.vendor.error_handler").for_show_error()

function ShowError.install(plugin_name, path, raw_opts)
  local opts = require("vendorlib.core.option").new(raw_opts)
  local spec = require("vendorlib.core.specification").from(path)
  return spec:install(plugin_name, opts.to)
end

return ShowError:methods()
