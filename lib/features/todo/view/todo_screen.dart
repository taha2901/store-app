import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/utils/app_colors.dart';
import 'package:store_app/features/todo/data/model/todo_model.dart';
import 'package:store_app/features/todo/logic/todo_cubit.dart';
import 'package:store_app/features/todo/logic/todo_states.dart';


class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TodoView();
  }
}

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final TextEditingController _controller = TextEditingController();
  int _editingIndex = -1;

  final List<String> filters = ['All', 'Active', 'Done'];

  String _editingTodoId = '';

  Color _priorityColor(String p) {
    switch (p) {
      case 'High':
        return AppColors.heartColor;
      case 'Medium':
        return AppColors.accent;
      default:
        return AppColors.successGreen;
    }
  }

  Future<void> _addOrEdit(TodoCubit cubit) async {
    if (_controller.text.trim().isEmpty) return;
    if (_editingIndex >= 0) {
      cubit.updateTodo(
        cubit.state.todos[_editingIndex]
            .copyWith(title: _controller.text.trim()),
      );
      _editingIndex = -1;
      _editingTodoId = '';
    } else {
      cubit.addTodo(Todo(title: _controller.text.trim()));
    }
    _controller.clear();
  }

  void _startEdit(TodoCubit cubit, int index) {
    setState(() {
      _editingIndex = index;
      _editingTodoId = cubit.state.todos[index].id.toString();
      _controller.text = cubit.state.todos[index].title;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TodoCubit>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('My Tasks',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.title,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  BlocBuilder<TodoCubit, TodoState>(
                    builder: (context, state) {
                      return Text(
                        '${cubit.completedCount} of ${state.todos.length} completed',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.bodyText),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<TodoCubit, TodoState>(
                    builder: (context, state) {
                      final value =
                          state.todos.isEmpty ? 0 : cubit.completedCount / state.todos.length;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: value.toDouble(),
                          backgroundColor: AppColors.divider,
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                          minHeight: 6,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(
                  filters.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => cubit.changeFilter(i),
                      child: Chip(
                        label: Text(filters[i]),
                        backgroundColor: cubit.state.selectedFilter == i
                            ? AppColors.primary
                            : AppColors.divider,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<TodoCubit, TodoState>(
                builder: (context, state) {
                  final todos = cubit.filteredTodos;
                  if (todos.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('✅', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(
                            cubit.state.selectedFilter == 2
                                ? 'No completed tasks'
                                : 'All done! 🎉',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.title),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: todos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final todo = todos[i];
                      final realIndex =
                          state.todos.indexWhere((t) => t.id == todo.id);
                      return Dismissible(
                        key: Key('todo-${todo.id}'),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => cubit.deleteTodo(todo),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.heartColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.delete_outline,
                              color: AppColors.heartColor, size: 22),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => cubit.toggleDone(todo),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: todo.done
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: todo.done
                                            ? AppColors.primary
                                            : AppColors.divider,
                                        width: 2),
                                  ),
                                  child: todo.done
                                      ? const Icon(Icons.check,
                                          color: Colors.white, size: 14)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  todo.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: todo.done
                                        ? AppColors.hintText
                                        : AppColors.title,
                                    decoration: todo.done
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _priorityColor(todo.priority),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _startEdit(cubit, realIndex),
                                child: const Icon(Icons.edit_outlined,
                                    size: 16, color: AppColors.bodyText),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _controller,
                        style:
                            const TextStyle(fontSize: 14, color: AppColors.title),
                        onSubmitted: (_) => _addOrEdit(cubit),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: _editingIndex >= 0
                              ? 'Edit task...'
                              : 'Add a new task...',
                          hintStyle: const TextStyle(
                              color: AppColors.hintText, fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _addOrEdit(cubit),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _editingIndex >= 0 ? Icons.check_rounded : Icons.add_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}