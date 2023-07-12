local templates = require('bloc.src.templates');
local utils = require('bloc.src.utils');

local import_statement = "import 'package:flutter_bloc/flutter_bloc.dart';";

local function get_parent_directory(path)
    local parent_directory = path:match("(.+\\).+")
    return parent_directory
end


-- local manager = require("neo-tree.sources.manager")
-- local state manager.get_state("filesystem")

-- local path = vim.api.nvim_buf_get_name(0)
--local path = vim.fn.expand('%')
-- local directory = get_parent_directory(path)

local tree_api = require "nvim-tree.api"

local function create_cubit(name, parent_folder_relative_path)
	local cubit_templates = templates.cubit;
	 local path = parent_folder_relative_path
	 local cubit_folder_path = path..name.."_cubit";
	 os.execute("mkdir "..cubit_folder_path)
	 cubit_folder_path = cubit_folder_path.."\\"
	 -- print("Cubit folder: "..cubit_folder_path)
	 local cubit_path = cubit_folder_path .. name .. "_cubit.dart";
	 local state_path = cubit_folder_path .. name .. "_state.dart";
	 print("Cubit file path:"..cubit_path)
	 print("State file path:"..state_path)

	 local cubit_text = utils.replace_in_template(name,  cubit_templates.file, import_statement )
	 local state_text = utils.replace_in_template(name,  cubit_templates.state, import_statement )
	 utils.create_file(cubit_path, cubit_text)
	 utils.create_file(state_path, state_text)
end
local function create_bloc(name, parent_folder_relative_path)
	 local bloc_templates = templates.bloc;
	 local path = parent_folder_relative_path
	 local bloc_folder_path = path..name.."_bloc";
	 os.execute("mkdir "..bloc_folder_path)
	 bloc_folder_path = bloc_folder_path.."\\"
	 -- print("bloc folder: "..bloc_folder_path)
	 local bloc_path = bloc_folder_path .. name .. "_bloc.dart";
	 local state_path = bloc_folder_path .. name .. "_state.dart";
	 local events_path = bloc_folder_path .. name .. "_events.dart";

	 local bloc_text = utils.replace_in_template(name,  bloc_templates.file, import_statement )
	 local state_text = utils.replace_in_template(name,  bloc_templates.state, import_statement )
	 local events_text = utils.replace_in_template(name,  bloc_templates.events, import_statement )

	 utils.create_file(bloc_path, bloc_text)
	 utils.create_file(state_path, state_text)
	 utils.create_file(events_path, events_text)
 end


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
	create_cubit(input, clipboard_after)
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
	create_bloc(input, clipboard_after)
end)

