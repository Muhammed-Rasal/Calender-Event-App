import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../Theme/reminder_theme.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSavedTasks();
  }

  bool _ispressed = false;

  CalendarWeekController _controller = CalendarWeekController();

  TextEditingController titleController = TextEditingController();

  TextEditingController timeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  int reminderCount = 0;

  String viewDate = '';

 
  List<String> tasks = [];

  saveTasks() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    sharedPrefs.setStringList('items', tasks);
    sharedPrefs.setString('date', viewDate);
    sharedPrefs.setString('selectedDate', _dateController.text);
  }

  getSavedTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      tasks = prefs.getStringList('items') ?? tasks;
      viewDate = prefs.getString('date') ?? viewDate;
      _dateController.text = prefs.getString('selectedDate') ?? '';
    });
    print(tasks);
    print(viewDate);
    print(_dateController.text);
  }

  removeSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('items');
  }

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              background: Colors.red,
              primary: Colors.black, // header background color
              onPrimary: Colors.red, // header text color
              onSurface: Colors.black87, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text =
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // getSavedTasks();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: const [
            SizedBox(
              width: 20,
            ),
            Text(
              'CALANDER',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
                color: Colors.red,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: Colors.red),
            onPressed: () {
              removeSavedData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.red),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.red),
            tooltip: 'ADD REMINDER',
            onPressed: () {
              //  _dateController.text =
              //               '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
              // tasks.add(titleController.text);
              //reminderCount++;
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Colors.black87,
                  insetPadding: EdgeInsets.zero,
                  contentTextStyle: GoogleFonts.mulish(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    'ADD EVENT',
                    style: headingTextStyle,
                  ),
                  content: SizedBox(
                    height: 133,
                    child: Column(
                      children: [
                        TextField(
                          controller: titleController,
                          style: contentTextStyle,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                            hintText: 'Title',
                            hintStyle: contentTextStyle,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: _dateController,
                          onTap: () {
                            _selectDate(context);
                          },
                          style: contentTextStyle,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                            hintText: 'choose a date',
                            hintStyle: contentTextStyle,
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        titleController.clear();
                        Navigator.pop(context, 'Cancel');
                      },
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        saveTasks();
                        // getSavedTasks();
                        tasks.add(titleController.text);
                        titleController.clear();

                        _dateController.text =
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';

                        print('choosed date:' + _dateController.text);

                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'ADD',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalendarWeek(
              todayDateStyle: const TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
              weekendsStyle: const TextStyle(color: Colors.white, fontSize: 15),
              dayOfWeekStyle: const TextStyle(color: Colors.white),
              dateStyle: const TextStyle(color: Colors.white, fontSize: 16),
              pressedDateBackgroundColor: Colors.white,
              pressedDateStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
              backgroundColor: Colors.black12,
              height: 100,
              showMonth: true,
              minDate: DateTime.now().add(
                const Duration(days: -365),
              ),
              maxDate: DateTime.now().add(
                const Duration(days: 365),
              ),
              onDatePressed: (DateTime datetime) {
                setState(() {
                  _ispressed = true;
                });
                print(_ispressed);
                //saveTasks();
                //getSavedTasks();
                //  setState(() {});

                // print(keyForSharedPrefs);
                viewDate = '${datetime.day}/${datetime.month}/${datetime.year}';

                print('view date:' + viewDate);
              },
              onDateLongPressed: (DateTime datetime) {
                _selectDate(context);
                // Do something
              },
              onWeekChanged: () {
                null;
                // Do something
              },
              monthViewBuilder: (DateTime time) => Align(
                alignment: FractionalOffset.center,
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      // '${_controller.selectedDate.day}/${_controller.selectedDate.month}/${_controller.selectedDate.year}',
                      DateFormat.yMMMM().format(time),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),
              decorations: [
                DecorationItem(
                    decorationAlignment: FractionalOffset.bottomRight,
                    date: DateTime.now(),
                    decoration: const Icon(
                      Icons.today_outlined,
                      color: Colors.red,
                    )),
              ],
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (BuildContext context, indexOfReminder) =>
                      _ispressed == true
                          ? ListTile(
                              title: _dateController.text == viewDate
                                  ? Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                          color: Colors.lightBlue.shade100,
                                          borderRadius:
                                              const BorderRadius.horizontal(
                                                  right: Radius.circular(10),
                                                  left: Radius.circular(10))),
                                      child: Center(
                                        child: Text(
                                          tasks[indexOfReminder].toUpperCase(),

                                          // titleController.text.toUpperCase(),
                                          textAlign: TextAlign.start,
                                          style: contentTextStyle,
                                        ),
                                      ),
                                    )
                                  : SizedBox())
                          : SizedBox(),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                        //color: Colors.blueGrey[100],
                        color: Colors.black,
                      ),
                  itemCount: tasks.length
                  // reminderCount,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
