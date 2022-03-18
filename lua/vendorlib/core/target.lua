local VendorTarget = {}
VendorTarget.__index = VendorTarget

function VendorTarget.new(raw_target)
  vim.validate({
    raw_target = { raw_target, { "string" } },
  })
  local file_path = vim.api.nvim_get_runtime_file("**/" .. raw_target, false)[1]
  if not file_path then
    return "not found target: " .. raw_target
  end

  local module_path = vim.split(file_path, "/lua/")[2]
  local parts = vim.split(module_path, "/", true)
  local lua_path = table.concat({ unpack(parts, 2) }, "/")

  local tbl = {
    _file_path = file_path,
    _lua_path = lua_path,
  }
  return setmetatable(tbl, VendorTarget)
end

function VendorTarget.install(self, ctx, to)
  vim.validate({
    ctx = { ctx, "table" },
    to = { to, "function" },
  })

  local path = to(ctx, {
    file_path = self._file_path,
    lua_path = self._lua_path,
  })

  local dir = vim.fn.fnamemodify(path, ":h")
  local ok = vim.fn.mkdir(dir, "p")
  if ok ~= 1 then
    return ("failed to mkdir: `%s`"):format(dir)
  end

  local copied = vim.loop.fs_copyfile(self._file_path, path)
  if copied ~= true then
    return ("failed to copy file: `%s` to `%s`"):format(self._file_path, path)
  end

  return nil
end

return VendorTarget
