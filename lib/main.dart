// ignore_for_file: prefer_const_constructors

import 'package:calender/Controller/SharedPrefrence_Controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/home/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider<TaskController>(
      create: (context) => TaskController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    ),
  );
}
