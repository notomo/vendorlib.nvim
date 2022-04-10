local messagelib = require("vendorlib.vendor.misclib.message")
local default_logger = {
  info = function(msg)
    messagelib.info(msg)
  end,
}

local M = {}

local InstallOption = {}
InstallOption.default = {
  to = function(ctx, module)
    return ("lua/%s/vendor/%s"):format(ctx.plugin_name, module.lua_path)
  end,
  logger = default_logger,
}
M.InstallOption = InstallOption

function InstallOption.new(raw_opts)
  vim.validate({ raw_opts = { raw_opts, "table", true } })
  raw_opts = raw_opts or {}
  return vim.tbl_deep_extend("force", InstallOption.default, raw_opts)
end

local AddOption = {}
AddOption.default = {
  path = "vendorlib.lua",
  logger = default_logger,
}
M.AddOption = AddOption

function AddOption.new(raw_opts)
  vim.validate({ raw_opts = { raw_opts, "table", true } })
  raw_opts = raw_opts or {}
  return vim.tbl_deep_extend("force", AddOption.default, raw_opts)
end

return M
