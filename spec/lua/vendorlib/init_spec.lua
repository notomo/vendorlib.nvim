local helper = require("vendorlib.lib.testlib.helper")
local vendorlib = helper.require("vendorlib")

describe("vendorlib.install()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("installs a library", function()
    local path = vim.fn.tempname()
    local f = io.open(path, "w")
    f:write(([[
return {
  targets = {
    {
      from = { names = { "message" } },
      to = function(ctx, from)
        return "%s" .. ctx.plugin_name .. "/" .. from.name .. ".lua"
      end
    }
  }
}
]]):format(helper.test_data_dir))
    f:close()

    vendorlib.install("test", path)

    assert.exists_file("test/message.lua")
  end)
end)
