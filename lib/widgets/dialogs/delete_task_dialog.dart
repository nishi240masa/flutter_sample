import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_sample/freezed_entities/todo_object.dart';

import 'package:flutter_sample/providers/todo_provider.dart';

class DeleteTodoTaskDialog extends HookConsumerWidget {
  const DeleteTodoTaskDialog({Key? key, required this.todoTask, required this.index}) : super(key: key);

  final TodoTask todoTask;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return AlertDialog(
      title: const Text("add text?"),
      content: Text(todoTask.content),
      actions: [
        ElevatedButton(
          child: const Text("cancel"),
          onPressed: () => context.pop(context),
        ),
        ElevatedButton(
          child: const Text("OK"),
          onPressed: () { 
            ref.watch(todoMangerNotifierProvider.notifier).deleteTask(index);
            context.pop();
            context.go("/");
          }
        ),
      ],
    );
  }
}