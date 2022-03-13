local Module = {}
Module.__index = Module

function Module.new(name)
  vim.validate({ name = { name, "string", true } })
  local path
  if name then
    path = vim.api.nvim_get_runtime_file(("lua/vendorlib/vendor/%s.lua"):format(name), false)[1]
  end
  local tbl = {
    _name = name,
    _path = path,
  }
  return setmetatable(tbl, Module)
end

function Module.install(self, ctx, to)
  vim.validate({
    ctx = { ctx, "table" },
    to = { to, "function" },
  })

  local path = to(ctx, { name = self._name })
  path = vim.fn.fnamemodify(path, ":p")

  local dir = vim.fn.fnamemodify(path, ":h")
  local ok = vim.fn.mkdir(dir, "p")
  if ok ~= 1 then
    return ("failed to mkdir: `%s`"):format(dir)
  end

  local copied = vim.loop.fs_copyfile(self._path, path)
  if copied ~= true then
    return ("failed to copy file: `%s` to `%s`"):format(self._path, path)
  end

  return nil
end

return Module
