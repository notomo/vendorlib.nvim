local License = {}

local _cache = {}

function License.validate(root_path)
  if _cache[root_path] then
    return nil
  end

  local license_path = vim.fs.joinpath(root_path, "LICENSE")
  local f = io.open(license_path, "r")
  if not f then
    return "not found license: " .. license_path
  end

  local license = f:read("*a")
  f:close()

  local can_copy = vim.startswith(
    license,
    [[Creative Commons Legal Code

CC0 1.0 Universal
]]
  )
  if not can_copy then
    return "cannot handle its license: " .. license_path
  end

  _cache[root_path] = true

  return nil
end

return License
