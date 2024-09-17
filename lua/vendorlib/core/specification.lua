local Context = require("vendorlib.core.context")

local Specification = {}
Specification.__index = Specification

function Specification.from(path)
  vim.validate({ path = { path, "string" } })
  local raw_targets = dofile(path)

  local targets, err = require("vendorlib.core.targets").new(raw_targets)
  if err then
    return err
  end
  local tbl = { _targets = targets }
  return setmetatable(tbl, Specification)
end

function Specification.install(self, plugin_name, logger, to)
  local ctx = Context.new(plugin_name, logger)
  return self._targets:install(ctx, to)
end

function Specification.add(added, opts)
  local git = vim.fn.finddir(".git", ".;")
  if git == "" then
    return "not found .git"
  end
  local root = vim.fn.fnamemodify(git, ":p:h:h")

  local dir_name = vim.fn.fnamemodify(root, ":t")
  local plugin_name = vim.split(dir_name, ".", { plain = true })[1]
  local path = root .. "/" .. opts.path:format(plugin_name)
  if vim.fn.filereadable(path) == 0 then
    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
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
