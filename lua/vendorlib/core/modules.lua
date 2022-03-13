local Modules = {}
Modules.__index = Modules

function Modules.new(raw_modules)
  vim.validate({ raw_modules = { raw_modules, "table", true } })
  local tbl = {
    _modules = raw_modules or {},
  }
  return setmetatable(tbl, Modules)
end

function Modules.add_names(self, names)
  vim.validate({ names = { names, "table" } })
  local raw_modules = self:all()
  for _, name in ipairs(names) do
    table.insert(raw_modules, require("vendorlib.core.module").new(name))
  end
  return Modules.new(raw_modules)
end

function Modules.all(self)
  local raw_modules = {}
  for _, m in ipairs(self._modules) do
    table.insert(raw_modules, m)
  end
  return raw_modules
end

return Modules
