local ShowError = require("vendorlib.vendor.misclib.error_handler").for_show_error()

function ShowError.install(plugin_name, path, raw_opts)
  local opts = require("vendorlib.core.option").new(raw_opts)
  local spec, err = require("vendorlib.core.specification").from(path)
  if err then
    return err
  end
  return spec:install(plugin_name, opts.logger, opts.to)
end

return ShowError:methods()
