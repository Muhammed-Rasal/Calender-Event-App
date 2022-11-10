import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskController extends ChangeNotifier {
  String viewDate = '';
  List<String> tasks = [];
  saveTasks() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setStringList(viewDate, tasks);
    sharedPrefs.setString('date', viewDate);
    notifyListeners();
  }

  removeSavedTasks(int removeIndex) async {
    tasks.removeAt(removeIndex);
    saveTasks();
    notifyListeners();
  }

  getSavedTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    viewDate = prefs.getString('date') ?? viewDate;
    tasks = prefs.getStringList(viewDate) ?? [];
    notifyListeners();
  }

  saveViewDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('date', viewDate);
    notifyListeners();
  }
}
