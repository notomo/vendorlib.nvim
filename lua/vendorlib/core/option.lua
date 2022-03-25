local messagelib = require("vendorlib.vendor.misclib.message")

local M = {}

M.default = {
  to = function(ctx, module)
    return ("lua/%s/vendor/%s"):format(ctx.plugin_name, module.lua_path)
  end,
  logger = {
    info = function(msg)
      messagelib.info(msg)
    end,
  },
}

function M.new(raw_opts)
  vim.validate({ raw_opts = { raw_opts, "table", true } })
  raw_opts = raw_opts or {}
  return vim.tbl_deep_extend("force", M.default, raw_opts)
end

return M