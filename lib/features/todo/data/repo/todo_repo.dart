import 'package:store_app/features/todo/data/model/todo_model.dart';
import 'package:store_app/features/todo/data/repo/todo_database.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
}

class TodoRepositoryImpl implements TodoRepository {
  final TodoDatabase db;

  TodoRepositoryImpl(this.db);

  @override
  Future<List<Todo>> getTodos() async {
    final data = await db.getTodos();
    return data.map((e) => Todo.fromMap(e)).toList();
  }

  @override
  Future<void> addTodo(Todo todo) async => await db.insertTodo(todo);

  @override
  Future<void> updateTodo(Todo todo) async => await db.updateTodo(todo);

  @override
  Future<void> deleteTodo(String id) async => await db.deleteTodo(id);
}