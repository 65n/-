import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';


class Themes{
static final light = ThemeData(
      backgroundColor:Colors.white,
      primaryColor:Colors.blue,
      brightness: Brightness.light
      );

static final dark = ThemeData(
  backgroundColor:Color(0xFF121212),
  primaryColor: Colors.yellow,
  brightness: Brightness.dark
  );
}

TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
    fontSize: 24,
    fontWeight:FontWeight.bold,
    color: Get.isDarkMode?Colors.grey[400]:Colors.grey,

  );
}
TextStyle get headingStyle{
  return GoogleFonts.lato(
      fontSize: 30,
      fontWeight:FontWeight.bold,
      color: Get.isDarkMode?Colors.white:Colors.black,
  );
}

TextStyle get titleStyle{
  return GoogleFonts.lato(
    fontSize: 16,
    fontWeight:FontWeight.w400,
    color: Get.isDarkMode?Colors.white:Colors.black,
  );
}
TextStyle get taskTitleStyle{
  return GoogleFonts.lato(
    fontSize: 20,
    fontWeight:FontWeight.w600,
    color: Get.isDarkMode?Colors.white:Colors.white,
  );
}

TextStyle get subTitleStyle{
  return GoogleFonts.lato(
    fontSize: 14,
    fontWeight:FontWeight.w400,
    color: Get.isDarkMode?Colors.grey[100]:Colors.grey[400],
  );
}
TextStyle get taskTimetyle{
  return GoogleFonts.lato(
    fontSize: 14,
    fontWeight:FontWeight.w400,
    color: Get.isDarkMode?Colors.white:Colors.white,
  );
}
TextStyle get noteTaskTimetyle{
  return GoogleFonts.lato(
    fontSize: 14,
    fontWeight:FontWeight.w500,
    color: Get.isDarkMode?Colors.white:Colors.white,
  );
}