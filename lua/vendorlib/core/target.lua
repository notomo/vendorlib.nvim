local VendorTarget = {}
VendorTarget.__index = VendorTarget

--- @param raw_target string
function VendorTarget.new(raw_target)
  local parts = vim.split(raw_target, "/", { plain = true })
  local plugin_name = parts[2]
  local ok, packadd_err = pcall(function()
    vim.cmd.packadd(plugin_name)
  end)
  if not ok then
    return packadd_err
  end
  local pattern = table.concat(vim.list_slice(parts, 3), "/")

  local file_path = vim.api.nvim_get_runtime_file(pattern, false)[1]
  if not file_path then
    return "not found target: " .. raw_target
  end

  local root_path = file_path:sub(1, #file_path - #pattern)
  local err = require("vendorlib.core.license").validate(root_path)
  if err then
    return err
  end

  local tbl = {
    _file_path = file_path,
    _lua_path = vim.split(file_path, "/lua/")[2],
    _target = raw_target,
  }
  return setmetatable(tbl, VendorTarget)
end

--- @param ctx table
--- @param to function
function VendorTarget.install(self, ctx, to)
  local path = to(ctx, {
    file_path = self._file_path,
    lua_path = self._lua_path,
  })

  local dir = vim.fn.fnamemodify(path, ":h")
  local ok = vim.fn.mkdir(dir, "p")
  if ok ~= 1 then
    return ("failed to mkdir: `%s`"):format(dir)
  end

  local copied = vim.uv.fs_copyfile(self._file_path, path)
  if copied ~= true then
    return ("failed to copy file: `%s` to `%s`"):format(self._file_path, path)
  end

  ctx.logger.info("installed: " .. self._target)

  return nil
end

return VendorTarget
