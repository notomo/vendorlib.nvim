local Context = require("vendorlib.core.context")

local Specification = {}

--- @param path string
function Specification.install(path, plugin_name, logger, to)
  local raw_targets = dofile(path)
  local ctx = Context.new(plugin_name, logger)

  local errs = require("vendorlib.vendor.misclib.multi_error").new()
  for _, raw_target in ipairs(raw_targets) do
    local err = require("vendorlib.core.target").install(raw_target, ctx, to)
    if err then
      errs:add(err)
    end
  end
  return errs:error()
end

function Specification.add(added, opts)
  local root = vim.fs.root(".", { ".git" })
  if not root then
    return "not found .git"
  end

  local dir_name = vim.fs.basename(root)
  local plugin_name = vim.split(dir_name, ".", { plain = true })[1]
  local path = vim.fs.joinpath(root, opts.path:format(plugin_name))
  if vim.fn.filereadable(path) == 0 then
    vim.fn.mkdir(vim.fs.dirname(path), "p")
    local f = io.open(path, "w")
    if not f then
      return "cannot open file" .. path
    end
    f:write([[return {}]])
    f:close()
    opts.logger.info([[created file: ]] .. path)
  end

  local raw_targets = dofile(path)

  added = vim
    .iter(added)
    :filter(function(target)
      return not vim.tbl_contains(raw_targets, target)
    end)
    :totable()
  for _, target in ipairs(added) do
    opts.logger.info([[added: ]] .. target)
  end

  vim.list_extend(raw_targets, added)
  table.sort(raw_targets, function(a, b)
    return a < b
  end)

  local indent = "  "
  local paths = vim
    .iter(raw_targets)
    :map(function(target)
      return ('%s"%s",\n'):format(indent, target)
    end)
    :totable()
  local content = "return {\n" .. table.concat(paths, "") .. "}\n"

  local f = io.open(path, "w")
  if not f then
    return "cannot open file" .. path
  end
  f:write(content)
  f:close()

  return nil
end

return Specification
