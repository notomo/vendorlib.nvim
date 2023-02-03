local helper = require("vusted.helper")
local plugin_name = helper.get_module_root(...)

helper.root = helper.find_plugin_root(plugin_name)

function helper.before_each()
  helper.test_data = require("vendorlib.vendor.misclib.test.data_dir").setup(helper.root)
end

function helper.after_each()
  helper.cleanup()
  helper.cleanup_loaded_modules(plugin_name)
  helper.test_data:teardown()
end

local asserts = require("vusted.assert").asserts
local asserters = require(plugin_name .. ".vendor.assertlib").list()
require(plugin_name .. ".vendor.misclib.test.assert").register(asserts.create, asserters)

asserts.create("exists_file"):register(function(self)
  return function(_, args)
    local path = helper.test_data.full_path .. args[1]
    self:set_positive(("`%s` not found file"):format(path))
    self:set_negative(("`%s` found file"):format(path))
    return vim.fn.filereadable(path) == 1
  end
end)

return helper
