import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final bool done;
  final String priority;

  Todo({
    String? id,
    required this.title,
    this.done = false,
    this.priority = 'Medium',
  }) : id = id ?? const Uuid().v4();

  Todo copyWith({
    String? title,
    bool? done,
    String? priority,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      done: done ?? this.done,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'done': done ? 1 : 0,
      'priority': priority,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String,
      title: map['title'] as String,
      done: (map['done'] as int) == 1,
      priority: map['priority'] as String,
    );
  }

  @override
  List<Object?> get props => [id, title, done, priority];
}