local Path = require 'plenary.path'
local os_sep = Path.path.sep

local function filename_first(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == '.' then
    return tail
  end
  return string.format('%s\t\t%s', tail, parent)
end

-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
local find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' }

-- Requires `fd` to be installed on the system
local function get_directories()
  local data = {}

  local handle = io.popen('fd --type d --hidden --exclude .git -X ls -h -d', 'r')
  if not handle then
    return
  end

  local result = handle:read '*a'
  handle:close()

  for entry in result:gmatch '[^\r\n]+' do
    table.insert(data, entry .. os_sep)
  end

  table.insert(data, 1, '.' .. os_sep)

  return data
end

return {
  filename_first = filename_first,
  find_command = find_command,
  get_directories = get_directories,
}
