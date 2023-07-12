local templates = require('bloc.src.templates');
local utils = require('bloc.src.utils');

local import_statement = "import 'package:flutter_bloc/flutter_bloc.dart';";

local M = {}

 function M.create_cubit(name, parent_folder_relative_path)
	local cubit_templates = templates.cubit;
	 local path = parent_folder_relative_path
	 local cubit_folder_path = path..name.."_cubit";
	 os.execute("mkdir "..cubit_folder_path)
	 cubit_folder_path = cubit_folder_path.."\\"
	 local cubit_path = cubit_folder_path .. name .. "_cubit.dart";
	 local state_path = cubit_folder_path .. name .. "_state.dart";

	 local cubit_text = utils.replace_in_template(name,  cubit_templates.file, import_statement )
	 local state_text = utils.replace_in_template(name,  cubit_templates.state, import_statement )
	 utils.create_file(cubit_path, cubit_text)
	 utils.create_file(state_path, state_text)
end
 function M.create_bloc(name, parent_folder_relative_path)
	 local bloc_templates = templates.bloc;
	 local path = parent_folder_relative_path
	 local bloc_folder_path = path..name.."_bloc";
	 os.execute("mkdir "..bloc_folder_path)
	 bloc_folder_path = bloc_folder_path.."\\"
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
 return M
