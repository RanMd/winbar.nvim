# winbar.nvim
Sets a winbar at the top for each file

<img width="865" alt="image" src="https://github.com/user-attachments/assets/42aa3205-2a9f-401a-bf4b-9c1cf6b15626">

## ✨ Features
- Shows if a file is modified and not saved
- Colored icons (using mini.icons highlightings)
- Integrates with diagnostics to highlight errors, warn, info, hints
- Can opt-out of icons and/or diagnostics
- Very fast!

## ⚡️ Dependencies
- [mini.icons](https://github.com/echasnovski/mini.icons) (icons) -- If ```config.icons = true```

## 📦 Installation

Install the plugin with your preferred package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
  {
    "RanMd/winbar.nvim",
    event = "VimEnter", -- Alternatively, BufReadPre if we don't care about the empty file when starting with 'nvim'
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      require("winbar").setup({
        -- your configuration comes here, for example:
        icons = true,
        diagnostics = true,
        buf_modified = true,
        buf_modified_symbol = "M",
        -- or use an icon
        -- buf_modified_symbol = "●"
        dim_inactive = {
            enabled = false,
            highlight = "WinBarNC",
        }
      })
    end
  },
}
```

## ⚙️ Configuration

### Setup
```lua
{
  icons = true,
  diagnostics = true,
  buf_modified = true,
  filetype_exclude = {
    "help",
    "startify",
    "dashboard",
    "packer",
    "neo-tree",
    "neogitstatus",
    "NvimTree",
    "Trouble",
    "alpha",
    "lir",
    "Outline",
    "spectre_panel",
    "toggleterm",
    "TelescopePrompt",
    "prompt"
  },
}
```

## Performance

### Startup

No startup impact since we use VimEnter to register the plugin.

### UI
On a Victus Gaming HP (using WSL)

<img width="356" alt="image" src="https://github.com/user-attachments/assets/7c2d963d-866e-4db5-89da-e9b1786a113a">

## Motivation
This plugin aims to help people move away from the tabline way of working but still need to orient them selves when working with multiple files by giving context.
The features are inspired by VSCode behaviour, some code is borrowed from bufferline, thanks for that 🙏.

## Thanks
Thanks to ramilito for creating this plugin and for focusing on efficiency. That emphasis is what led to trying it, and it even resulted in forking the project.
[original plugin](https://github.com/Ramilito/winbar.nvim/tree/main)
