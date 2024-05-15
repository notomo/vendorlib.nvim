local util = require("genvdoc.util")
local plugin_name = vim.env.PLUGIN_NAME
local full_plugin_name = plugin_name .. ".nvim"

local example_path = ("./spec/lua/%s/example.lua"):format(plugin_name)

require("genvdoc").generate(full_plugin_name, {
  chapters = {
    {
      name = function(group)
        return "Lua module: " .. group
      end,
      group = function(node)
        if node.declaration == nil or node.declaration.type ~= "function" then
          return nil
        end
        return node.declaration.module
      end,
    },
    {
      name = "STRUCTURE",
      group = function(node)
        if node.declaration == nil or node.declaration.type ~= "class" then
          return nil
        end
        return "STRUCTURE"
      end,
    },
    {
      name = "EXAMPLES",
      body = function()
        return util.help_code_block_from_file(example_path, { language = "lua" })
      end,
    },
  },
})

local gen_readme = function()
  local exmaple = util.read_all(example_path)

  local content = ([[
# %s

This is a plugin to copy from local installed plugin files to another.

## Example

```lua
%s```]]):format(full_plugin_name, exmaple)

  util.write("README.md", content)
end
gen_readme()
