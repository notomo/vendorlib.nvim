local helper = require("ntf.helper")
local plugin_name = helper.get_module_root(...)

helper.root = helper.find_plugin_root(plugin_name)
vim.opt.packpath:prepend(vim.fs.joinpath(helper.root, "spec/.shared/packages"))
require("assertlib").register(require("ntf.assert").register)

function helper.before_each()
  helper.test_data = require("vendorlib.vendor.misclib.test.data_dir").setup(vim.fs.joinpath(helper.root, "spec"))
end

function helper.after_each()
  helper.test_data:teardown()
end

local assert = require("ntf.assert")

assert.register("exists_file", function(self)
  return function(_, args)
    local path = helper.test_data:path(args[1])
    self:set_positive(("`%s` not found file"):format(path))
    self:set_negative(("`%s` found file"):format(path))
    return vim.fn.filereadable(path) == 1
  end
end)

function helper.typed_assert(raw_assert)
  local x = require("assertlib").typed(raw_assert)
  ---@cast x +{exists_file:fun(path)}
  ---@cast x +{no:{exists_file:fun(path)}}
  return x
end

return helper
