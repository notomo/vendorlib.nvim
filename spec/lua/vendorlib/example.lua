local vendor_spec_file_path = vim.fn.tempname()
local f = io.open(vendor_spec_file_path, "w")
f:write([[
return {
  plugin_name = "example",
  targets = {
    {
      from = { names = { "message", "collection/ordered_dict" } },
    }
  }
}]])
f:close()

require("vendorlib").install(vendor_spec_file_path)
