rex.bind("cmd+d", "pane.split", { direction = "right" })

-- Tmux-style prefix and pane controls.
rex.bind("ctrl+a>\\", "pane.split", { direction = "right" })
rex.bind("ctrl+a>-", "pane.split", { direction = "down" })
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })

rex.bind("ctrl+a>h", "pane.focus.left")
rex.bind("ctrl+a>j", "pane.focus.down")
rex.bind("ctrl+a>k", "pane.focus.up")
rex.bind("ctrl+a>l", "pane.focus.right")
rex.bind("ctrl+a>z", "pane.zoom")
rex.bind("ctrl+a>c", "client.tab.new")
rex.bind("ctrl+a>[KeyX]", "client.tab.close")
rex.bind("ctrl+a>n", "client.tab.next")
rex.bind("ctrl+a>p", "client.tab.previous")
rex.bind("ctrl+a>s", "session.switch")
rex.bind("ctrl+a>shift+n", "session.next")
rex.bind("ctrl+a>shift+p", "session.previous")

rex.mode("resize", { exclusive = true })

rex.action{
  name = "resize_repeat",
  title = "Resize Pane and Keep Resizing",
  args = { direction = "string" },
  run = function(ctx, args)
    rex.client.queue("pane.resize", { direction = args.direction, amount = 5 })
    rex.client.queue("client.mode.enter", { name = "resize" })
  end,
}

local resize_keys = { h = "left", j = "down", k = "up", l = "right" }
for key, direction in pairs(resize_keys) do
  rex.bind("ctrl+a>shift+" .. key, "resize_repeat", { direction = direction })
  rex.bind("resize/" .. key, "pane.resize", { direction = direction, amount = 5 })
  rex.bind("resize/shift+" .. key, "pane.resize", { direction = direction, amount = 5 })
end
rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")

local function terminal_directory()
  local result = rex.block.call("com.superlogical.terminal", "pwd", {})
  local path = result and result.pwd

  if not path then
    local processes = rex.block.call("com.superlogical.terminal", "process", {})
    path = processes and processes.foreground and processes.foreground.cwd
      or processes and processes.child and processes.child.cwd
  end

  if path and path:match("^file://") then
    path = path:match("^file://[^/]*(/.*)$") or path
    path = path:gsub("%%(%x%x)", function(hex)
      return string.char(tonumber(hex, 16))
    end)
  end

  return path
end

local function open_popup(ctx, command, bounds, label, shell)
  if not ctx.session_id or not ctx.block_id then
    error("tmux popup needs a focused terminal pane", 0)
  end

  local cwd = terminal_directory()
  local result, err = rex.session.new_layer{
    session_id = ctx.session_id,
    bounds = bounds,
    focus = true,
    layout = {
      block = {
        flavor = "com.superlogical.terminal.shell",
        label = label,
        options = {
          command = command,
          cwd = cwd,
          shell = shell,
        },
      },
    },
  }
  if err then error(err, 0) end
  return result
end

rex.action{
  name = "popup_lazygit",
  title = "Open Lazygit Popup",
  run = function(ctx)
    return open_popup(ctx, {
      "zsh",
      "-lic",
      "exec lazygit",
    }, { 0.05, 0.05, 0.9, 0.9 }, "lazygit", "none")
  end,
}

rex.action{
  name = "popup_shell",
  title = "Open Shell Popup",
  run = function(ctx)
    return open_popup(ctx, { "zsh", "-i" }, { 0.125, 0.125, 0.75, 0.75 }, "zsh")
  end,
}

rex.bind("ctrl+a>ctrl+y", "popup_lazygit")
rex.bind("ctrl+a>ctrl+t", "popup_shell")
