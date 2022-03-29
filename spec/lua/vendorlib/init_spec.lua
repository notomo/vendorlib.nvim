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

  it("does nothing if no license", function()
    vim.opt.runtimepath:prepend(helper.test_data_dir .. "root")
    helper.new_directory("root/lua/no_license")
    helper.new_file("root/lua/no_license/init.lua")

    local path = vim.fn.tempname()
    local f = io.open(path, "w")
    f:write(([[
return {
  "lua/no_license/init.lua"
}
]]):format(helper.test_data_dir))
    f:close()

    vendorlib.install("xxxx", path, {
      to = function()
        error("unreachable")
      end,
    })
    --
    assert.no.exists_file("no_license/init.lua")
  end)

  it("does nothing if license is not CC0 1.0", function()
    vim.opt.runtimepath:prepend(helper.test_data_dir .. "root")
    helper.new_directory("root/lua/other_license")
    helper.new_file("root/LICENSE")
    helper.new_file("root/lua/other_license/init.lua")

    local path = vim.fn.tempname()
    local f = io.open(path, "w")
    f:write(([[
return {
  "lua/other_license/init.lua"
}
]]):format(helper.test_data_dir))
    f:close()

    vendorlib.install("xxxx", path, {
      to = function()
        error("unreachable")
      end,
    })
    --
    assert.no.exists_file("other_license/init.lua")
  end)
end)
