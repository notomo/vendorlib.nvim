local Context = require("vendorlib.core.context")

local Specification = {}
Specification.__index = Specification

function Specification.from(path)
  vim.validate({ path = { path, "string" } })
  local raw_targets = dofile(path)

  local targets, err = require("vendorlib.core.targets").new(raw_targets)
  if err then
    return nil, err
  end
  local tbl = { _targets = targets }
  return setmetatable(tbl, Specification), nil
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
  local plugin_name = vim.split(dir_name, ".", true)[1]
  local path = root .. "/" .. opts.path:format(plugin_name)
  if vim.fn.filereadable(path) == 0 then
    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
    local f = io.open(path, "w")
    f:write([[return {}]])
    f:close()
    opts.logger.info([[created file: ]] .. path)
  end

  local raw_targets = dofile(path)

  added = vim.tbl_filter(function(target)
    return not vim.tbl_contains(raw_targets, target)
  end, added)
  for _, target in ipairs(added) do
    opts.logger.info([[added: ]] .. target)
  end

  vim.list_extend(raw_targets, added)
  table.sort(raw_targets, function(a, b)
    return a < b
  end)

  -- HACK: to use formatter on write
  local bufnr = vim.fn.bufadd(path)
  vim.fn.bufload(bufnr)

  local content = "return " .. vim.inspect(raw_targets):gsub("{", "{\n"):gsub(" }", ",\n}")
  local lines = vim.split(content, "\n", false)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd.write({ mods = { silent = true } })
  end)

  return nil
end

return Specification
