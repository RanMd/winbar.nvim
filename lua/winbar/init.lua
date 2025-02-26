local utils = require("winbar.utils")
local config = require("winbar.config")
local M = {}

local function augroup(name)
  return vim.api.nvim_create_augroup("winbar_" .. name, { clear = true })
end

local function get_path()
  local path = vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":.")
  return path
end

---@return string
function M.get_winbar(opts)
  local diagnostics = {}
  local icon, hl_icon = "", ""
  local hl_bfn = "WinBar"
  local should_dim = not opts.active and config.options.dim_inactive.enabled

  if config.options.diagnostics then
    diagnostics = utils.get_diagnostics()
  end

  if config.options.icons then
    icon, hl_icon = utils.get_icon(M.get_icon)
  end

  -- Build section a (icon)
  local sectionA = table.concat({ " %#", hl_icon, "#", icon, " " })

  if diagnostics.level == "error" then
    hl_bfn = "DiagnosticError"
  elseif diagnostics.level == "warning" then
    hl_bfn = "DiagnosticWarn"
  elseif diagnostics.level == "info" then
    hl_bfn = "DiagnosticInfo"
  elseif diagnostics.level == "hint" then
    hl_bfn = "DiagnosticHint"
  end

  -- Build section b (buffer name )
  local sectionB = table.concat({ " %#", hl_bfn, "%#", "%t " })

  -- Don't highlight name if the window is not active
  if should_dim then
    hl_bfn = config.options.dim_inactive.highlight
  end

  -- Build section c (path)
  local sectionC = "%#WinBarDir#" .. get_path()

  -- Build section d (buffer modified)
  local sectionD = ""

  if vim.api.nvim_get_option_value("mod", {}) and config.options.buf_modified_symbol then
    sectionD = M.mod_icon
  end

  local winbar = table.concat({ sectionA, sectionB, sectionC, sectionD, "%*" })

  return winbar
end

function M.register()
  local events = { "VimEnter", "BufEnter", "BufModifiedSet", "WinEnter", "WinLeave" }
  if config.options.diagnostics then
    table.insert(events, "DiagnosticChanged")
  end

  vim.api.nvim_create_autocmd(events, {
    group = augroup("winbar"),
    callback = function(args)
      vim.schedule(function()
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
        for _, pattern in ipairs(config.options.filetype_exclude) do
          if vim.fn.match(filetype, pattern) ~= -1 then
            local ok, winbar_set_by_plugin = pcall(vim.api.nvim_buf_get_var, 0, "winbar_set_by_winbar_nvim")
            if ok and winbar_set_by_plugin then
              vim.opt_local.winbar = nil
              vim.api.nvim_buf_set_var(0, "winbar_set_by_winbar_nvim", false)
            end
            return
          end
        end

        local win_number = vim.api.nvim_get_current_win()
        local win_config = vim.api.nvim_win_get_config(win_number)

        if win_config.relative == "" then
          local bar = " " .. "%*" .. M.get_winbar({ active = args.event ~= "WinLeave" }) .. "%*"
          vim.api.nvim_set_option_value("winbar", bar, { scope = "local", win = win_number })
          vim.api.nvim_buf_set_var(0, "winbar_set_by_winbar_nvim", true)
        else
          vim.opt_local.winbar = nil
          vim.api.nvim_buf_set_var(0, "winbar_set_by_winbar_nvim", false)
        end
      end)
    end,
  })
end

function M.setup(options)
  config.setup(options)

  if config.options.icons then
    local has_devicons, web_icons = pcall(require, "mini.icons")
    if not has_devicons then
      vim.notify("Icons is set to true but dependency mini.icons is missing")
    end
    M.get_icon = web_icons.get
    M.mod_icon = "%=" .. "%#BufferCurrentMod#" .. config.options.buf_modified_symbol .. " "
  end

  M.register()
end

return M
