local M = {}
local defaults = {
  icons = true,
  diagnostics = true,
  buf_modified = true,
  buf_modified_symbol = "M",
  -- dir_levels = 0,
  dim_inactive = {
    enabled = false,
    highlight = "WinBarNC",
    -- icons = true,
    -- name = true,
  },
  -- Avoid duplicates
  filetype_exclude = {
    "k8s_*",
    "snacks_*",
    "NeogitStatus",
    "NvimTree",
    "Outline",
    "TelescopePrompt",
    "Trouble",
    "aerial",
    "alpha",
    "dap-repl",
    "dashboard",
    "help",
    "lir",
    "neo-tree",
    "packer",
    "prompt",
    "spectre_panel",
    "startify",
    "toggleterm",
    "trouble",
  },
}

M.options = {}

function M.setup(options)
  local combined_options = vim.tbl_deep_extend("force", {}, defaults, options or {})

  if options and options.filetype_exclude then
    combined_options.filetype_exclude = vim.list_extend(defaults.filetype_exclude, options.filetype_exclude)
  end

  M.options = combined_options
end

M.setup()
return M
