local helper = require("vendorlib.test.helper")
local vendorlib = helper.require("vendorlib")

describe("vendorlib.install()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("installs libraries", function()
    vim.opt.packpath:prepend(helper.test_data_dir .. "packages")

    helper.new_directory("packages/pack/test/opt/plugin_name/lua/has_license")
    helper.new_file(
      "packages/pack/test/opt/plugin_name/LICENSE",
      [[
Creative Commons Legal Code

CC0 1.0 Universal
]]
    )
    helper.new_file("packages/pack/test/opt/plugin_name/lua/has_license/init.lua")
    helper.new_file("packages/pack/test/opt/plugin_name/lua/has_license/example.lua")

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
        return helper.test_data_dir .. ("%s/vendor/%s"):format(ctx.plugin_name, module.lua_path)
      end,
    })

    assert.exists_file("test/vendor/has_license/example.lua")
    assert.exists_file("test/vendor/has_license/init.lua")
  end)

  it("does nothing if no license", function()
    vim.opt.packpath:prepend(helper.test_data_dir .. "packages")

    helper.new_directory("packages/pack/test/opt/plugin_name/lua/no_license")
    helper.new_file("packages/pack/test/opt/plugin_name/lua/no_license/init.lua")

    local path = vim.fn.tempname()
    local f = io.open(path, "w")
    f:write([[
return {
  "user_name/plugin_name/lua/no_license/init.lua"
}
]])
    f:close()

    vendorlib.install("xxxx", path, {
      to = function()
        error("unreachable")
      end,
    })

    assert.no.exists_file("lua/no_license/init.lua")
    assert.exists_message("not found license: ")
  end)

  it("does nothing if license is not CC0 1.0", function()
    vim.opt.packpath:prepend(helper.test_data_dir .. "packages")

    helper.new_directory("packages/pack/test/opt/plugin_name/lua/other_license")
    helper.new_file("packages/pack/test/opt/plugin_name/LICENSE")
    helper.new_file("packages/pack/test/opt/plugin_name/lua/other_license/init.lua")

    local path = vim.fn.tempname()
    local f = io.open(path, "w")
    f:write([[
return {
  "user_name/plugin_name/lua/other_license/init.lua"
}
]])
    f:close()

    vendorlib.install("xxxx", path, {
      to = function()
        error("unreachable")
      end,
    })

    assert.no.exists_file("lua/other_license/init.lua")
    assert.exists_message("cannot handle its license: ")
  end)
end)

describe("vendorlib.add()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("creates new spec file if the file does not exist", function()
    vendorlib.add({}, { path = helper.test_data_path .. "vendorlib.lua" })
    assert.exists_file("vendorlib.lua")
  end)

  it("adds entries to spec file", function()
    helper.new_file(
      "vendorlib.lua",
      [[
return {"test2"}
]]
    )

    vendorlib.add({ "test1", "test3" }, { path = helper.test_data_path .. "vendorlib.lua" })
    local actual = dofile(helper.test_data_dir .. "vendorlib.lua")
    assert.is_same({ "test1", "test2", "test3" }, actual)
  end)
end)
