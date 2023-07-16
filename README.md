# Bloc.nvim

Flutter Bloc.nvim is a Neovim replacement for the bloc extension in Vscode that provide easy bloc template generation and wrapping with bloc widgets. For more information on Flutter and Bloc, please checkout the following links:
1. [Flutter website](https://flutter.dev/)
2. [Bloc website](https://bloclibrary.dev/)

## Features

- **Bloc Template Generation**: Quickly generate boilerplate code for your BLoC classes, including events, states, and the bloc itself. 

- **Bloc Widget Wrapping**: Effortlessly wrap your Flutter widgets with bloc-related classes, such as `BlocBuilder` and `BlocProvider`, with a few simple commands. Bloc.nvim eliminates the hassle of manually importing and setting up these widgets, allowing you to focus on your app's core logic.

## Installation

1. Make sure you have Neovim installed on your system. You can download it from the official [Neovim website](https://neovim.io/).

2. Install the BLoc.nvim plugin with your prefered package manager:

   ```Packer (lua)
   use 'RobertPietraru/bloc.nvim'
   ```

   ```Vim-Plug (vim)
   Plug 'RobertPietraru/bloc.nvim'
   ```

3. Configure the language server

4. Open your Flutter project in Neovim.

## Usage

### Bloc Template Generation

1. To generate a BLoC template, position your cursor on the line where you want to create the BLoC class.

2. Run the following command:

   ```lua
    require('bloc').create_cubit('cubit_name', 'parent/folder/relative/path')
    require('bloc').create_bloc('bloc_name', 'parent/folder/relative/path')
   ```

   For example:

   ```vim
    :lua require('bloc').create_cubit('cubit_name', 'parent/folder/relative/path')
    :lua require('bloc').create_bloc('bloc_name', 'parent/folder/relative/path')
   ```

This will create a new BLoC class file with the necessary boilerplate code, including events, states, and the bloc itself.

### Bloc Widget Wrapping
Bloc.nvim uses null-ls to add additional actions to the language server's default code actions. Make sure you have it installed

1. To wrap a widget with a bloc-related class, position your cursor on the line containing the widget.

2. Run the following command:
    ```lua
     vim.lsp.buf.code_action()
    ```

    ```vim
     lua: vim.lsp.buf.code_action()
    ```

    This will show you a list of all possible code actions

## Configuration
Currently you can't do much, but we are on it
Here's my personal config for the plugin using nvim-tree

```
local tree_api = require('nvim-tree.api')
local bloc = require('bloc')

--- for widget wrapping
bloc.setup()

--- the cubit will be the child of the folder or the sibling of the file
vim.keymap.set("n", "<leader>q", function()
	local input = vim.fn.input("name (snake_case): ")
	if (input == "")then
		print("Aborted cubit creation")
				return;
    end
	local clipboard_before = vim.fn.getreg("*");
	tree_api.fs.copy.relative_path()
	local clipboard_after = vim.fn.getreg("*");
	vim.fn.setreg("*", clipboard_before)
	bloc.create_cubit(input, clipboard_after)
end)

vim.keymap.set("n", "<leader>Q", function()
	local input = vim.fn.input("name (snake_case): ")
	if (input == "")then
		print("Aborted bloc creation")
		return;
	end
	local clipboard_before = vim.fn.getreg("*");
	tree_api.fs.copy.relative_path()
	local clipboard_after = vim.fn.getreg("*");
	vim.fn.setreg("*", clipboard_before)
	bloc.create_bloc(input, clipboard_after)
end)


-- TODO: remove this if you want, though you should always format after wrapping the widgets
vim.keymap.set("n", "tt", function()
		vim.lsp.buf.format()
end)

```
## Contributing

We welcome contributions to Bloc.nvim! If you encounter any issues or have ideas for enhancements, please submit them to our [GitHub repository](RobertPietraru/bloc.nvim). We appreciate your feedback and pull requests.

## License

Bloc.nvim is licensed under the [MIT License](https://opensource.org/licenses/MIT). Feel free to use and distribute this plugin while keeping the license information intact.

---

Thank you for using Bloc.nvim! We hope this plugin improves your Flutter development experience. If you have any questions or need support, don't hesitate to reach out to us. Happy coding!
