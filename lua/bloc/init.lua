local templates = require('bloc.src.templates');
local utils = require('bloc.src.utils');

local import_statement = "import 'package:flutter_bloc/flutter_bloc.dart';";

local M = {}

function M.create_cubit(name, parent_folder_relative_path)
	local cubit_templates = templates.cubit;
	local path = parent_folder_relative_path
	local cubit_folder_path = path .. name .. "_cubit";
	os.execute("mkdir " .. cubit_folder_path)
	cubit_folder_path = cubit_folder_path .. "\\"
	local cubit_path = cubit_folder_path .. name .. "_cubit.dart";
	local state_path = cubit_folder_path .. name .. "_state.dart";

	local cubit_text = utils.replace_in_template(name, cubit_templates.file, import_statement)
	local state_text = utils.replace_in_template(name, cubit_templates.state, import_statement)
	utils.create_file(cubit_path, cubit_text)
	utils.create_file(state_path, state_text)
end

function M.create_bloc(name, parent_folder_relative_path)
	local bloc_templates = templates.bloc;
	local path = parent_folder_relative_path
	local bloc_folder_path = path .. name .. "_bloc";
	os.execute("mkdir " .. bloc_folder_path)
	bloc_folder_path = bloc_folder_path .. "\\"
	local bloc_path = bloc_folder_path .. name .. "_bloc.dart";
	local state_path = bloc_folder_path .. name .. "_state.dart";
	local events_path = bloc_folder_path .. name .. "_events.dart";

	local bloc_text = utils.replace_in_template(name, bloc_templates.file, import_statement)
	local state_text = utils.replace_in_template(name, bloc_templates.state, import_statement)
	local events_text = utils.replace_in_template(name, bloc_templates.events, import_statement)

	utils.create_file(bloc_path, bloc_text)
	utils.create_file(state_path, state_text)
	utils.create_file(events_path, events_text)
end

local function is_white_space(str, pos)
	local _str = string.sub(str, pos, pos)
	return _str == " " or _str == '\t' or _str == ',' or _str == ')'
end

local function find_widget_with_brackets()
	local current_line = vim.api.nvim_get_current_line()
	local startIndex, endIndex = string.find(current_line, '%(')
	local line_length = string.len(current_line)
	while not is_white_space(current_line, startIndex) do
		startIndex = startIndex - 1;
	end

	if (is_white_space(current_line, startIndex)) then
		startIndex = startIndex + 1
	end

	while not is_white_space(current_line, endIndex) and endIndex < line_length do
		if string.sub(current_line, endIndex, endIndex) == '(' then break end
		endIndex = endIndex + 1;
	end

	if is_white_space(current_line, endIndex) then
		endIndex = endIndex - 1
	end

	return { startIndex, endIndex }
end

local function tbl_length(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

--  modified  snippet taken from from  fzf-lua
local function get_visual_selection()
	local _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
	local _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
	if cerow < csrow then csrow, cerow = cerow, csrow end
	local lines = vim.fn.getline(csrow, cerow)
	local n = tbl_length(lines)
	if n <= 0 then return '' end
	lines[n] = string.sub(lines[n], 1, cscol)
	lines[1] = string.sub(lines[1], cecol)
	return table.concat(lines, "\n")
end

function M.select_widget()
	local current_line = vim.api.nvim_get_current_line()
	local x = string.find(current_line, '%(')
	if (x == nil) then
		vim.cmd(vim.api.nvim_replace_termcodes('normal viw', true, true, true))
		return get_visual_selection()
	end

	local start, stop = unpack(find_widget_with_brackets())

	local label_and_first_parantheses = string.sub(current_line, start, stop)

	if (label_and_first_parantheses == '(' or label_and_first_parantheses == '') then
		print('Bloc was not able to detect a widget')
		return nil
	end

	vim.cmd(vim.api.nvim_replace_termcodes('normal ebvf(%', true, true, true))

	return get_visual_selection()
end

local function write_to_template(widget, input, template)
	vim.api.nvim_feedkeys('d', 'n', true)
	vim.api.nvim_feedkeys('i', 'n', true)
	local with_widget = string.gsub(template, '{widget}', widget);
	local with_input = string.gsub(with_widget, '{input}', input);
	vim.api.nvim_feedkeys(with_input, 'n', true)
end

function M.setup()
	local null_ls = require 'null-ls'
	null_ls.register({
		name = 'Bloc Actions',
		method = { require 'null-ls'.methods.CODE_ACTION },
		filetypes = { '_all' },
		generator = {
			fn = function()
				return { {
					title = 'Wrap with BlocBuilder',
					action = function()
						local child = M.select_widget()
						if (child == nil) then print('Bloc was not able to detect a widget') end
						local input = vim.fn.input("name: ")
						write_to_template(child, input, [[BlocBuilder<{input}Bloc, {input}State>(
		builder: (context, state) {
			return {widget};
		}) ]])
						vim.lsp.buf.format()
					end
				},
					{
						title = 'Wrap with BlocProvider',
						action = function()
							local child = M.select_widget()
							if (child == nil) then print('Bloc was not able to detect a widget') end
							local input = vim.fn.input("name: ")
							write_to_template(child, input, [[BlocProvider(
		  create: (context) => {input}Bloc(),
		  child: {widget}
		) ]])
							vim.lsp.buf.format()
						end
					},
					{
						title = 'Wrap with BlocConsumer',
						action = function()
							local child = M.select_widget()
							if (child == nil) then print('Bloc was not able to detect a widget') end
							local input = vim.fn.input("name: ")
							write_to_template(child, input, [[BlocConsumer<{input}Bloc, {input}State>(
		listenWhen: (previous, current) {},
		listener: (context, state) {},
		builder: (context, state) {
			return {widget};
		},
		)
		]])
							vim.lsp.buf.format()
						end
					},
					{
						title = 'Wrap with BlocSelector',
						action = function()
							local child = M.select_widget()
							if (child == nil) then print('Bloc was not able to detect a widget') end
							local input = vim.fn.input("name: ")
							write_to_template(child, input, [[BlocSelector<{input}Bloc, {input}State, SelectedState>(
                  selector: (state) {
                    return state;
                  },
                  builder: (context, state) {
                    return {widget};
                  },
                )]])

							vim.lsp.buf.format()
						end
					}, {
					title = 'Wrap with BlocListener',
					action = function()
						local child = M.select_widget()
						if (child == nil) then print('Bloc was not able to detect a widget') end
						local input = vim.fn.input("name: ")
						write_to_template(child, input, [[BlocListener<{input}Bloc, {input}State>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  child: {widget},
                )]])

						vim.lsp.buf.format()
					end
				}, {
					title = 'Wrap with RepositoryProvider',
					action = function()
						local child = M.select_widget()
						if (child == nil) then print('Bloc was not able to detect a widget') end
						local input = vim.fn.input("name: ")
						write_to_template(child, input, [[RepositoryProvider(
                  create: (context) => {input}Repository(),
                  child: {widget},
                )]])

						vim.lsp.buf.format()
					end
				} }
			end
		}
	})

	null_ls.setup()
end


return M
