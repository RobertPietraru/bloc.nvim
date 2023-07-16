local M = {}
M.file = [[
import 'package:equatable/equatable.dart';
{bloc_path}

part '{snake_case}_state.dart';

class {pascal_case}Cubit extends Cubit<{pascal_case}State> {
  {pascal_case}Cubit() : super(const {pascal_case}InitialState());
}
]]

M.state = [[
part of '{snake_case}_cubit.dart';

abstract class {pascal_case}State extends Equatable {
  const {pascal_case}State();
}

class {pascal_case}Initial extends {pascal_case}State {
  const {pascal_case}Initial();
  @override
  List<Object?> get props => [];
}
]]
return M
