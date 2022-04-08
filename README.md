# vendorlib.nvim

WIP

## Example

```lua
local vendor_spec_file_path = vim.fn.tempname()
local f = io.open(vendor_spec_file_path, "w")
f:write([[
return {
  "notomo/example_target.nvim/lua/example_target/init.lua",
}]])
f:close()

require("vendorlib").install("example", vendor_spec_file_path)
```