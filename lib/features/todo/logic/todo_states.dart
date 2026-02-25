import 'package:equatable/equatable.dart';
import 'package:store_app/features/todo/data/model/todo_model.dart';

class TodoState extends Equatable {
  final List<Todo> todos;
  final int selectedFilter;

  const TodoState({this.todos = const [], this.selectedFilter = 0});

  TodoState copyWith({List<Todo>? todos, int? selectedFilter}) {
    return TodoState(
      todos: todos ?? this.todos,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [todos, selectedFilter];
}