local helper = require("vendorlib.test.helper")
local vendorlib = helper.require("vendorlib")

describe("vendorlib.install()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("installs a library", function()
    local path = vim.fn.tempname()
    local f = io.open(path, "w")
    f:write(([[
return {
  "lua/vendorlib/test/data/example.lua"
}
]]):format(helper.test_data_dir))
    f:close()

    vendorlib.install("test", path, {
      to = function(ctx, module)
        return helper.test_data_dir .. ("%s/vendor/%s"):format(ctx.plugin_name, module.lua_path)
      end,
    })

    assert.exists_file("test/vendor/vendorlib/test/data/example.lua")
  end)
end)
