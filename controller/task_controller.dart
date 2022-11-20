import 'package:get/get.dart';
import 'package:newtask/db/ad_helper.dart';
import 'package:newtask/models/task.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }
  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }
  void getTasks() async{
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());

  }
}