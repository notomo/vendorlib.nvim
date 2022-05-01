local plugin_name = vim.split((...):gsub("%.", "/"), "/", true)[1]
local helper = require("vusted.helper")

helper.root = helper.find_plugin_root(plugin_name)
helper.packpath = vim.o.packpath

function helper.before_each()
  vim.o.packpath = helper.packpath
  helper.test_data = require("vendorlib.vendor.misclib.test.data_dir").setup(helper.root)
end

function helper.after_each()
  vim.cmd("tabedit")
  vim.cmd("tabonly!")
  vim.cmd("silent %bwipeout!")
  helper.cleanup_loaded_modules(plugin_name)
  helper.test_data:teardown()
  print(" ")
end

local asserts = require("vusted.assert").asserts

asserts.create("exists_file"):register(function(self)
  return function(_, args)
    local path = helper.test_data.full_path .. args[1]
    self:set_positive(("`%s` not found file"):format(path))
    self:set_negative(("`%s` found file"):format(path))
    return vim.fn.filereadable(path) == 1
  end
end)

asserts.create("exists_message"):register(function(self)
  return function(_, args)
    local expected = args[1]
    self:set_positive(("`%s` not found message"):format(expected))
    self:set_negative(("`%s` found message"):format(expected))
    local messages = vim.split(vim.api.nvim_exec("messages", true), "\n")
    for _, msg in ipairs(messages) do
      if msg:match(expected) then
        return true
      end
    end
    return false
  end
end)

return helper
