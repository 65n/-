import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newtask/db/ad_helper.dart';
import 'package:newtask/models/categores.dart';
import 'package:newtask/services/theme_servies.dart';
import 'package:newtask/ui/add_task_bar.dart';
import 'package:newtask/ui/home.dart';
import 'package:newtask/ui/theme.dart';

void initFirebase() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  initFirebase();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,

    theme: Themes.light,
    darkTheme: Themes.dark,
    themeMode: ThemeService().theme,
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/todo': (context) => AddTaskPage(),

    },

  ));
}

