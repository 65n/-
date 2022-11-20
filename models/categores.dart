import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:newtask/models/tasks.dart';
import 'package:newtask/ui/theme.dart';

class Categores extends StatefulWidget {
  @override
  State<Categores> createState() => _CategoresState();
}

class _CategoresState extends State<Categores> {
  final tasksList = Task.generateTasks();
  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }
  void initState() {
    super.initState();
    initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDbTask();
  }

  Widget _buildAddTask() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(20),
        dashPattern: [10, 10],
        color: Colors.grey,
        child: Center(
            child: Text(
          '+',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
    );
  }

  Widget _buildTask(BuildContext context, Task task) {
    return Column(
      children: [
            GestureDetector(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: task.bgColor, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    task.iconData,
                    color: task.iconColor,
                    size: 35,
                  ),

                  Text(
                    task.title!,
                    style: titleStyle,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      _buildTaskStatus(
                          task.btnColor!, task.iconColor!, '${task.left} left'),
                      SizedBox(width: 5),
                      _buildTaskStatus(
                          Colors.white, task.iconColor!, '${task.done} done')
                    ],
                  )
                ],
              ),
            ),
            onTap: () {
              if (task.localPage == '/pokupka') {
                _pokupka(context);
              } else {
                Navigator.pop(context);
                Navigator.pushNamed(context, task.localPage.toString());
              }
            },
          ),
      ],
    );
  }
  Widget _buildDbTask() {
    return
        Expanded(
          child:Column(
            children: [
              GestureDetector(
                      child:
                      Container(
                        height: 180,
                        padding:EdgeInsets.all(8),
                        child: GridView.builder(
                            shrinkWrap: false,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: tasksList.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing:10,
                                mainAxisSpacing: 0
                            ),
                            itemBuilder: (context, index) =>
                             _buildTask(context,  tasksList[index])
                        ),
                      )),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('categories')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot>  snapshot) {
                      var s = snapshot.data!.docs;
                      if (s != null) {
                        var len = s.length; // Safe
                      }
                      var len = snapshot.data!.docs.length;
                      return GridView.builder(
                        itemCount: len,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: Colors.indigoAccent,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.account_circle),
                                      SizedBox(height: 30),
                                      Text(
                                        snapshot.data!.docs[index].get('name'),
                                        style: titleStyle,
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Row(
                                        children: [],
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, '/somethingTodo');
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }),
              ),
            ],
          )
        );
  }
  _pokupka(BuildContext context) {
    showBottomSheet(
      context: context,
      backgroundColor: Color(40353600),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        width: 500,
        decoration: new BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(50),
            topRight: const Radius.circular(50.0),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Список покупок",
              style: headingStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskStatus(Color bgColor, Color txColor, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(
        text,
        style: TextStyle(color: txColor),
      ),
    );
  }
}
