local M = {}

function M.install(plugin_name, path, raw_opts)
  local opts = require("vendorlib.core.option").InstallOption.new(raw_opts)
  local spec = require("vendorlib.core.specification").from(path)
  if type(spec) == "string" then
    local err = spec
    return err
  end
  return spec:install(plugin_name, opts.logger, opts.to)
end

function M.add(raw_targets, raw_opts)
  vim.validate({ targets = { raw_targets, "table" } })
  local opts = require("vendorlib.core.option").AddOption.new(raw_opts)
  return require("vendorlib.core.specification").add(raw_targets, opts)
end

return M
