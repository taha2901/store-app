import 'package:bloc/bloc.dart';
import 'package:store_app/features/todo/data/model/todo_model.dart';
import 'package:store_app/features/todo/data/repo/todo_repo.dart';
import 'package:store_app/features/todo/logic/todo_states.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository _repo;

  TodoCubit(this._repo) : super(const TodoState()) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      final todos = await _repo.getTodos();
      emit(state.copyWith(todos: todos));
    } catch (e) {
      // لو في مشكلة في التحميل نفضل على الـ state الحالي
    }
  }

  Future<void> addTodo(Todo todo) async {
    await _repo.addTodo(todo);
    await loadTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    await _repo.updateTodo(todo);
    await loadTodos();
  }

  Future<void> deleteTodo(Todo todo) async {
    await _repo.deleteTodo(todo.id);
    await loadTodos();
  }

  Future<void> toggleDone(Todo todo) async {
    await updateTodo(todo.copyWith(done: !todo.done));
  }

  void changeFilter(int index) => emit(state.copyWith(selectedFilter: index));

  List<Todo> get filteredTodos {
    switch (state.selectedFilter) {
      case 1:
        return state.todos.where((t) => !t.done).toList();
      case 2:
        return state.todos.where((t) => t.done).toList();
      default:
        return state.todos;
    }
  }

  int get completedCount => state.todos.where((t) => t.done).length;
}