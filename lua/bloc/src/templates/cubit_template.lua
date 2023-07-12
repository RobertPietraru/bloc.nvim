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

class {pascal_case}InitialState extends {pascal_case}State {
  const {pascal_case}InitialState();
  @override
  List<Object?> get props => [];
}

class {pascal_case}ErrorState extends {pascal_case}State {

  const {pascal_case}ErrorState();
  @override
  List<Object?> get props => [];
}

class {pascal_case}LoadingState extends {pascal_case}State {
  const {pascal_case}LoadingState();
  @override
  List<Object?> get props => [];
}

class {pascal_case}RetrivedState extends {pascal_case}State {

  const {pascal_case}RetrivedState();

  @override
  List<Object?> get props => [];
}

]]
return M
