# vendorlib.nvim

WIP

## Example

```lua
local vendor_spec_file_path = vim.fn.tempname()
local f = io.open(vendor_spec_file_path, "w")
f:write([[
return {
  targets = {
    {
      from = { names = { "message", "collection/ordered_dict" } },
    }
  }
}]])
f:close()

require("vendorlib").install("example", vendor_spec_file_path)
```