import 'package:flutter/material.dart';


class Task {
  IconData? iconData;
  String? title;
  Color? bgColor;
  Color? iconColor;
  Color? btnColor;
  bool isLast;
  num? left;
  num? done;
  String? localPage;
  Task({this.iconColor, this.title, this.bgColor, this.left,this.isLast = false,this.iconData,this.btnColor,this.done, this.localPage});
  static List<Task> generateTasks(){
    return[
      Task(
        iconData:Icons.person_rounded,
        title:'Личное',
        bgColor: Color(0xFFFFF7EC),
        iconColor: Color(0xFFFAF0DA),
        btnColor:Color(0xFFEBBB7F),
        left: 3,
        done: 1,
        localPage:'/',
      ),
      Task(
        iconData:Icons.shopping_basket,
        title:'Список покупок',
        bgColor:Color(0xFF84F6DE) ,
        iconColor: Color(0xFF7F3EA9),
        btnColor:Color(0xFFEBBB7F),
        left: 3,
        done: 1,
        localPage:'/pokupka',
      ),
    ];
  }
}