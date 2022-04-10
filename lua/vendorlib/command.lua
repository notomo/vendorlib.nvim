local ShowError = require("vendorlib.vendor.misclib.error_handler").for_show_error()

function ShowError.install(plugin_name, path, raw_opts)
  local opts = require("vendorlib.core.option").InstallOption.new(raw_opts)
  local spec, err = require("vendorlib.core.specification").from(path)
  if err then
    return err
  end
  return spec:install(plugin_name, opts.logger, opts.to)
end

function ShowError.add(raw_targets)
  vim.validate({ targets = { raw_targets, "table" } })
  return require("vendorlib.core.specification").add(raw_targets)
end

return ShowError:methods()
