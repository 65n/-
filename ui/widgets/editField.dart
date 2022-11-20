import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:newtask/ui/theme.dart';


class MyEditField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final TextEditingController? text;
  final Widget? widget;


  const MyEditField({Key? key, required this.title, required this.hint, this.controller, this.widget, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle,),
          Container(
            height: 52,
            margin: EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              border:Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
                children:[ Expanded(
                  child:TextFormField(
                    readOnly: widget==null?false:true, //если это виджет, то можно вписывать, если нет, то нельзя
                    autofocus: false,
                    cursorColor:Get.isDarkMode?Colors.grey[100]:Colors.grey[700] ,
                    controller: text,
                    style: subTitleStyle,

                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.theme.backgroundColor,
                            width: 0,
                          )
                      ),
                    ),
                  ) ,
                ),
                  widget == null?Container():Container(child: widget,)// Если виджет, то мы рисуем, если нет, то не рисуем
                ]
            ),

          )
        ],
      ),
    );
  }
}
