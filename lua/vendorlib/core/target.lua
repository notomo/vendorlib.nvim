local VendorTarget = {}

--- @param raw_target string
--- @param ctx table
--- @param to function
function VendorTarget.install(raw_target, ctx, to)
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

  local path = to(ctx, {
    file_path = file_path,
    lua_path = vim.split(file_path, "/lua/")[2],
  })

  local dir = vim.fs.dirname(path)
  if vim.fn.mkdir(dir, "p") ~= 1 then
    return ("failed to mkdir: `%s`"):format(dir)
  end

  local copied = vim.uv.fs_copyfile(file_path, path)
  if copied ~= true then
    return ("failed to copy file: `%s` to `%s`"):format(file_path, path)
  end

  ctx.logger.info("installed: " .. raw_target)

  return nil
end

return VendorTarget
