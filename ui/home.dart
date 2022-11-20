import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newtask/services/theme_servies.dart';
import 'package:newtask/ui/add_task_bar.dart';
import 'package:newtask/ui/category.dart';
import 'package:newtask/ui/theme.dart';
import 'package:newtask/ui/widgets/buttons.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:newtask/ui/widgets/editField.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List todoList = [];
  bool isChecked = false;
  var check = Colors.black;
  List<String> repeatList = ["None", "Daily", "Weekend", "Monthly"];

  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  void initState() {
    super.initState();
    initFirebase();
    todoList.addAll(['Buy Milk', 'Wash dishes', 'Купить что-то']);
  }

  _bodyBar() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('items').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return  const Text('Нет записей');
        return Scaffold(
            body: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.yMMMMd().format(DateTime.now()),
                              style: subHeadingStyle,
                            ),
                            Text(
                              "Сегодня",
                              style: headingStyle,
                            )
                          ],
                        ),
                      ),
                      MyButton(
                          label: "+ Add Task",
                          onTap: () => Get.to(AddTaskPage()))
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: DatePicker(
                DateTime.now(),
                height: 100,
                width: 80,
                initialSelectedDate: DateTime.now(),
                selectionColor: Color(0xFF4e5ae8),
                selectedTextColor: Colors.white,
                dateTextStyle: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
                onDateChange: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    //print(documentSnapshot.data());
                    if (documentSnapshot.get('repeat') == 'Daily') {
                      return Dismissible(
                        key: Key(documentSnapshot.id),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 0),
                          child: Container(
                            width: 100,
                            height: 130,
                            child: Card(
                              color: documentSnapshot.get('color') == 0
                                  ? Colors.indigo
                                  : documentSnapshot.get('color') == 1
                                      ? Colors.pinkAccent
                                      : Colors.orange,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(26),
                                  top: Radius.circular(26),
                                ),
                              ),
                              child: ListTile(
                                  leading: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(26),
                                        top: Radius.circular(26),
                                      ),
                                    ),
                                    value: documentSnapshot.get('isCompleted'),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        FirebaseFirestore.instance
                                            .collection('items')
                                            .doc(snapshot.data!.docs[index].id)
                                            .update({'isCompleted': value!});
                                      });
                                    },
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(documentSnapshot.get('title'),
                                          style: taskTitleStyle),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.alarm_add_outlined,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                              documentSnapshot
                                                      .get('startTime') +
                                                  " - ",
                                              style: taskTimetyle),
                                          Text(documentSnapshot.get('endTime'),
                                              style: taskTimetyle),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(documentSnapshot.get('note'),
                                          style: noteTaskTimetyle),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.redAccent,
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('items')
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .delete();
                                        },
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    TextEditingController _titleController =
                                            TextEditingController(),
                                        _noteController =
                                            TextEditingController(),
                                        _dateController =
                                            TextEditingController(),
                                        _repeatController =
                                            TextEditingController();
                                    String _selectedRepeat =
                                        documentSnapshot.get('repeat');
                                    _titleController.text =
                                        documentSnapshot.get('title');
                                    _noteController.text =
                                        documentSnapshot.get('note');
                                    _dateController.text =
                                        documentSnapshot.get('date');
                                    _repeatController.text =
                                        documentSnapshot.get('repeat');

                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Color(40353600),
                                      builder: (context) => Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.90,
                                        decoration: new BoxDecoration(
                                          color: context.theme.backgroundColor,
                                          borderRadius: new BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(35),
                                            topRight:
                                                const Radius.circular(35),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 6,
                                              width: 120,
                                              margin: EdgeInsets.only(top: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            Text("Изменить задачу", style: headingStyle,),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  MyEditField(
                                                      title: "Title",
                                                      hint: "something",
                                                      text: _titleController),
                                                  MyEditField(
                                                      title: "Note",
                                                      hint: "something",
                                                      text: _noteController),
                                                  MyEditField(
                                                      title: "Date",
                                                      hint: "something",
                                                      text: _dateController),
                                                  MyEditField(
                                                    title: "Repeat",
                                                    hint: "$_repeatController",
                                                    text: _repeatController,
                                                    widget: DropdownButton(
                                                      icon: Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          color: Colors.grey),
                                                      iconSize: 32,
                                                      elevation: 4,
                                                      underline: Container(
                                                        height: 0,
                                                      ),
                                                      style: subTitleStyle,
                                                      items: repeatList.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String? value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value!,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          _repeatController.text = newValue!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(height: 30),
                                                  GestureDetector(
                                                    onTap: () {
                                                      FirebaseFirestore.instance
                                                          .collection('items')
                                                          .doc(snapshot.data!.docs[index].id)
                                                          .update({'title': _titleController.text.toString(), 'note':_noteController.text.toString(), 'date':_dateController.text.toString(), 'repeat':_repeatController.text.toString()});
                                                    },
                                                    child: Container(
                                                      width: 250,
                                                      height: 75,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color:
                                                            Color(0xFF4e5ae8),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          right: 10.0,
                                                          bottom: 1.0,
                                                          top: 20),
                                                      child: Text(
                                                        "Изменить",
                                                        style: taskTitleStyle,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          FirebaseFirestore.instance
                              .collection('items')
                              .doc(snapshot.data!.docs[index].id)
                              .delete();
                        }, // Удаление Карточки
                      );
                    }
                    if (documentSnapshot.get('date') ==
                        DateFormat.yMd().format(_selectedDate)) {
                      return Dismissible(
                        key: Key(documentSnapshot.id),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 0),
                          child: Container(
                            width: 100,
                            height: 130,
                            child: Card(
                              color: documentSnapshot.get('color') == 0
                                  ? Colors.indigo
                                  : documentSnapshot.get('color') == 1
                                  ? Colors.pinkAccent
                                  : Colors.orange,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(26),
                                  top: Radius.circular(26),
                                ),
                              ),
                              child: ListTile(
                                  leading: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(26),
                                        top: Radius.circular(26),
                                      ),
                                    ),
                                    value: documentSnapshot.get('isCompleted'),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        FirebaseFirestore.instance
                                            .collection('items')
                                            .doc(snapshot.data!.docs[index].id)
                                            .update({'isCompleted': value!});
                                      });
                                    },
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(documentSnapshot.get('title'),
                                          style: taskTitleStyle),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.alarm_add_outlined,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                              documentSnapshot
                                                  .get('startTime') +
                                                  " - ",
                                              style: taskTimetyle),
                                          Text(documentSnapshot.get('endTime'),
                                              style: taskTimetyle),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(documentSnapshot.get('note'),
                                          style: noteTaskTimetyle),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.redAccent,
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('items')
                                              .doc(
                                              snapshot.data!.docs[index].id)
                                              .delete();
                                        },
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    TextEditingController _titleController =
                                    TextEditingController(),
                                        _noteController =
                                        TextEditingController(),
                                        _dateController =
                                        TextEditingController(),
                                        _repeatController =
                                        TextEditingController();
                                    String _selectedRepeat =
                                    documentSnapshot.get('repeat');
                                    _titleController.text =
                                        documentSnapshot.get('title');
                                    _noteController.text =
                                        documentSnapshot.get('note');
                                    _dateController.text =
                                        documentSnapshot.get('date');
                                    _repeatController.text =
                                        documentSnapshot.get('repeat');

                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Get.isDarkMode?Colors.black:Colors.white,
                                      builder: (context) => Container(
                                        height:
                                        MediaQuery.of(context).size.height *
                                            0.90,
                                        decoration: new BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: new BorderRadius.only(
                                            topLeft:
                                            const Radius.circular(25.0),
                                            topRight:
                                            const Radius.circular(25.0),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 6,
                                              width: 120,
                                              margin: EdgeInsets.only(top: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            Text("Изменить задачу", style: headingStyle,),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  MyEditField(
                                                      title: "Title",
                                                      hint: "something",
                                                      text: _titleController),
                                                  MyEditField(
                                                      title: "Note",
                                                      hint: "something",
                                                      text: _noteController),
                                                  MyEditField(
                                                      title: "Date",
                                                      hint: "something",
                                                      text: _dateController),
                                                  MyEditField(
                                                    title: "Repeat",
                                                    hint: "$_repeatController",
                                                    text: _repeatController,
                                                    widget: DropdownButton(
                                                      icon: Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          color: Colors.grey),
                                                      iconSize: 32,
                                                      elevation: 4,
                                                      underline: Container(
                                                        height: 0,
                                                      ),
                                                      style: subTitleStyle,
                                                      items: repeatList.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                              (String? value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Text(value!,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey)),
                                                            );
                                                          }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          _repeatController.text = newValue!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(height: 30),
                                                  GestureDetector(
                                                    onTap: () {
                                                      FirebaseFirestore.instance
                                                          .collection('items')
                                                          .doc(snapshot.data!.docs[index].id)
                                                          .update({'title': _titleController.text.toString(), 'note':_noteController.text.toString(), 'date':_dateController.text.toString(), 'repeat':_repeatController.text.toString()});
                                                    },
                                                    child: Container(
                                                      width: 250,
                                                      height: 75,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(20),
                                                        color:
                                                        Color(0xFF4e5ae8),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          right: 10.0,
                                                          bottom: 1.0,
                                                          top: 20),
                                                      child: Text(
                                                        "Изменить",
                                                        style: taskTitleStyle,
                                                        textAlign:
                                                        TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          FirebaseFirestore.instance
                              .collection('items')
                              .doc(snapshot.data!.docs[index].id)
                              .delete();
                        }, // Удаление Карточки
                      );
                    } else
                      return Container();
                  }),
            ),
          ],
        ));
      },
    );
  }

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appbar(),
      body: _bodyBar(),
    );
  }
}

_appbar() {
  return AppBar(
    elevation: 0,
    backgroundColor: Get.isDarkMode ? Color(0xFF121212) : Colors.white,
    leading: GestureDetector(
      onTap: () {
        ThemeService().switchTheme();
      },
      child: Icon(
        Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
        size: 20,
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
    ),
    actions: [
      GestureDetector(
        onTap: () => Get.to(const Category()),
        child: Icon(
          Icons.grid_on,
          size: 25,
          color: Get.isDarkMode ? Colors.grey : Colors.black,
        )
      ),

      SizedBox(
        width: 20,
      ),
    ],
  );
}
