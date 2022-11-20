
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:newtask/models/categores.dart';


class Category extends StatelessWidget {
  const Category({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(25),
            child: Text("Список дел",style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold
            ),),
          ),
              Categores(),
              
        ],
      ),
    );
  }
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Get.isDarkMode?Colors.black:Colors.white,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode ?Colors.white:Colors.black,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.account_circle_outlined,
            size: 30,
            color: Get.isDarkMode ?Colors.white:Colors.black,
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
