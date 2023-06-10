import 'dart:convert';

import 'package:flutter_sample/device/file_io.dart';
import 'package:flutter_sample/freezed_entities/todo_object.dart';
import 'package:flutter_sample/repositories/todo_repository.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'todo_provider.g.dart';

String savePath = "save-data.json";

@Riverpod(keepAlive: true)
class TodoMangerNotifier extends _$TodoMangerNotifier {
  
  /**
   * アプリを起動して初めてデータが読み込まれる時の関数です。
   * 既に使用履歴があって、端末保存がされていれば、そこからTodoリスト等を読み込みます。
   * 特に何も保存されていない場合は、中が空のインスタンスを返します。
   */
  
  @override
  FutureOr<TodoManager> build() async { 
    try {
      return TodoManager.fromJson(jsonDecode(await readSaveData(savePath)));
    } catch (e) {
      return TodoManager(
      todoTaskList: [
          TodoTask(
            id: const Uuid().v4(), 
            content: "初めてのメモ", 
            createdDateTime: DateTime.now(), 
            updatedDateTime: DateTime.now()
          ),
          TodoTask(
            id: const Uuid().v4(), 
            content: "二回目のメモ", 
            createdDateTime: DateTime.now(), 
            updatedDateTime: DateTime.now()
          ),
        ]
      );
    }
  }

  /**
   * ここが制御部分になります。これらの関数が呼び出された時に、TodoManagerのデータに変更が起こります。
   * 主にタスクの追加・更新・削除等を行い、その変更分を逐次、端末保存で記録します。
   * add, update, deleteで共通したコード(手続き処理, アルゴリズム)は
   * todo_repositoryに投げて、そこからの各ユースケースはここで書いています。
   */

  TodoTask? searchTaskFromId(String id) {
    for (TodoTask todoTask in state.value!.todoTaskList) {
      if (todoTask.id == id) return todoTask;
    }
    return null;
  }

  void addTask2(TodoTask todoTask) async {
    state = AsyncValue.data(await todoTaskListUpdateAndSave(state.value!, savePath, (todoTaskList) {
      // don't use todoTaskList.add(todoTask);
      return [...todoTaskList, todoTask];
    }));
  }

  void updateTask2(TodoTask updatedTodoTask) async {
    state = AsyncValue.data(await todoTaskListUpdateAndSave(state.value!, savePath, (todoTaskList) {
      return [
        for (TodoTask todoTask in todoTaskList)
          if (todoTask.id == updatedTodoTask.id) updatedTodoTask
          else todoTask
      ];
    }));
  }

  void deleteTask2(String id) async {
    state = AsyncValue.data(await todoTaskListUpdateAndSave(state.value!, savePath, (todoTaskList) {
      return [
        for (TodoTask todoTask in todoTaskList)
          if (todoTask.id != id) todoTask,
      ];
    }));
  }

  void addTask(TodoTask todoTask) async {
    TodoManager tmpTodoManager = state.value!;
    List<TodoTask> tmpTodoTaskList = tmpTodoManager.todoTaskList;
    tmpTodoTaskList = [...tmpTodoTaskList, todoTask];
    TodoManager updatedTodoManger = tmpTodoManager.copyWith(todoTaskList: [...tmpTodoTaskList]);
    await writeSaveData(savePath, jsonEncode(tmpTodoManager.toJson()));
    for (TodoTask todoTask in tmpTodoTaskList) {
      print(todoTask.content);
    }
    for (TodoTask todoTask in updatedTodoManger.todoTaskList) {
      print(todoTask.content);
    }
    print("");
    state = AsyncValue.data(updatedTodoManger);
  }

  void updateTask(TodoTask todoTask, int index) async {
    TodoManager tmpTodoManager = state.value!;
    List<TodoTask> tmpTodoTaskList = tmpTodoManager.todoTaskList;
    tmpTodoTaskList[index] = todoTask;
    tmpTodoManager.copyWith(todoTaskList: tmpTodoTaskList);
    await writeSaveData(savePath, jsonEncode(tmpTodoManager.toJson()));
    state = AsyncValue.data(tmpTodoManager);
  }

  void deleteTask(int index) async {
    TodoManager tmpTodoManager = state.value!;
    List<TodoTask> tmpTodoTaskList = [];
    int i = 0;
    for (TodoTask todoTask in tmpTodoManager.todoTaskList) {
      if (i != index) tmpTodoTaskList.add(todoTask);
      i++;
    }
    tmpTodoManager.copyWith(todoTaskList: tmpTodoTaskList);
    await writeSaveData(savePath, jsonEncode(tmpTodoManager.toJson()));
    state = AsyncValue.data(tmpTodoManager);
  }
}
