local helper = require("vendorlib.test.helper")
local vendorlib = helper.require("vendorlib")

describe("vendorlib.install()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("installs libraries", function()
    vim.opt.packpath:prepend(helper.test_data:path("packages"))

    helper.test_data:create_file(
      "packages/pack/test/opt/plugin_name/LICENSE",
      [[
Creative Commons Legal Code

CC0 1.0 Universal
]]
    )
    helper.test_data:create_file("packages/pack/test/opt/plugin_name/lua/has_license/init.lua")
    helper.test_data:create_file("packages/pack/test/opt/plugin_name/lua/has_license/example.lua")

    local path = vim.fn.tempname()
    local f = io.open(path, "w")
    f:write([[
return {
  "user_name/plugin_name/lua/has_license/example.lua",
  "user_name/plugin_name/lua/has_license/init.lua"
}
]])
    f:close()

    vendorlib.install("test", path, {
      to = function(ctx, module)
        return helper.test_data:path(("%s/vendor/%s"):format(ctx.plugin_name, module.lua_path))
      end,
    })

    assert.exists_file("test/vendor/has_license/example.lua")
    assert.exists_file("test/vendor/has_license/init.lua")
  end)

  it("does nothing if no license", function()
    vim.opt.packpath:prepend(helper.test_data:path("packages"))

    helper.test_data:create_file("packages/pack/test/opt/plugin_name/lua/no_license/init.lua")

    local path = vim.fn.tempname()
    local f = io.open(path, "w")
    f:write([[
return {
  "user_name/plugin_name/lua/no_license/init.lua"
}
]])
    f:close()

    local ok, err = pcall(function()
      vendorlib.install("xxxx", path, {
        to = function()
          error("unreachable")
        end,
      })
    end)
    assert.is_false(ok)

    assert.no.exists_file("lua/no_license/init.lua")
    assert.match("not found license: ", err)
  end)

  it("does nothing if license is not CC0 1.0", function()
    vim.opt.packpath:prepend(helper.test_data:path("packages"))

    helper.test_data:create_file("packages/pack/test/opt/plugin_name/LICENSE")
    helper.test_data:create_file("packages/pack/test/opt/plugin_name/lua/other_license/init.lua")

    local path = vim.fn.tempname()
    local f = io.open(path, "w")
    f:write([[
return {
  "user_name/plugin_name/lua/other_license/init.lua"
}
]])
    f:close()

    local ok, err = pcall(function()
      vendorlib.install("xxxx", path, {
        to = function()
          error("unreachable")
        end,
      })
    end)
    assert.is_false(ok)

    assert.no.exists_file("lua/other_license/init.lua")
    assert.match("cannot handle its license: ", err)
  end)
end)

describe("vendorlib.add()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("creates new spec file if the file does not exist", function()
    vendorlib.add({}, { path = helper.test_data:relative_path("vendorlib.lua") })
    assert.exists_file("vendorlib.lua")
  end)

  it("adds entries to spec file", function()
    helper.test_data:create_file(
      "vendorlib.lua",
      [[
return {"test2"}
]]
    )

    vendorlib.add({ "test1", "test3" }, { path = helper.test_data:relative_path("vendorlib.lua") })
    local actual = dofile(helper.test_data:path("vendorlib.lua"))
    assert.is_same({ "test1", "test2", "test3" }, actual)
  end)
end)
