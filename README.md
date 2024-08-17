# NukeTools for Neovim

A Neovim plugin for seamless integration with Nuke, allowing you to execute Python/BlinkScript code in Nuke directly from your Neovim editor.

## Features

- Connect to Nuke via NukeServerSocket
- Send Python/BlinkScript code from Neovim to Nuke
- Display Nuke's output in Neovim
- Support for whole buffer and selected text execution

## Installation

Using [LazyVim](https://github.com/LazyVim/LazyVim):

```lua
return {
  {
   "sisoe24/nuketools.nvim",
    keys = {
      { "<leader>nk", ":ExecuteInNuke<CR>" , desc = "Execute in Nuke" },
      { "<leader>nk", ":ExecuteSelectionInNuke<CR>", mode = { "v" }, desc = "Execute selection in Nuke" },
    },
    opts = {
    --   clearOutput = true,
    --   formatOutput = true,
    --   host = "127.0.0.1",
    --   port = 54321,
    },
  },
}

```

## Configuration

All configuration options are optional and have default values.

- `clearOutput`: Clear output buffer before sending code to Nuke. Default: `true`
- `formatOutput`: Format Nuke's output based on NukeServerSocket's output format. Default: `true`
- `host`: NukeServerSocket's host. Default: `"127.0.0.1"`. Change only if you wish to connect to a _specific_ host.
- `port`: NukeServerSocket's port. Default: `54321`. Change only if you wish to connect to a _specific_ port. The extension will automatically pick the NukeServerSocket's port if is changed in Nuke's preferences (requires neovim to be restarted).

## Usage

- `:ExecuteInNuke`: Execute the whole buffer in Nuke
- `:ExecuteInNuke {code}`: Execute the argument in Nuke
- `:ExecuteSelectionInNuke`: Execute the selected text in Nuke

> [!NOTE]
> The extension does not provide any keybindings by default. You can add your own keybindings by using the `keys` field in the LazyVim configuration (see [above](#installation)).

## Requirements

- [NukeServerSocket](https://github.com/sisoe24/nukeserversocket) plugin
- Currently using Neovim 0.10.0 but should work with previous versions as well.

## License

[MIT License](LICENSE)

## Acknowledgements

This plugin is inspired by the [Nuke-Tools](https://github.com/sisoe24/Nuke-Tools) extension for Visual Studio Code.
