local M = {}

 M.file = [[
{bloc_path}
import 'package:equatable/equatable.dart';

part '{snake_case}_event.dart';
part '{snake_case}_state.dart';

class {pascal_case}Bloc extends Bloc<{pascal_case}Event, {pascal_case}State> {
  {pascal_case}Bloc() : super({pascal_case}Initial()) {
    on<{pascal_case}Event>((event, emit) {
      // TODO: implement event handler
    });
  }
}
]]

M.events = [[
part of '{snake_case}_bloc.dart';

abstract class {pascal_case}Event extends Equatable {
  const {pascal_case}Event();

  @override
  List<Object> get props => [];
}
]]


M.state = [[
part of '{snake_case}_bloc.dart';

abstract class {pascal_case}State extends Equatable {
  const {pascal_case}State();
  
  @override
  List<Object> get props => [];
}

class {pascal_case}Initial extends {pascal_case}State {}
]]

return M
