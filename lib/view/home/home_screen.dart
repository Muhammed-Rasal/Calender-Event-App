import 'package:calender/Controller/SharedPrefrence_Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../utilities/theme/text_styles.dart';
import '../widget/alert_box_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  TextEditingController titleController = TextEditingController();
  final weekController = CalendarWeekController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Text(
              'CALENDER',
              style: titleTextStyle,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.red),
            tooltip: 'ADD REMINDER',
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    AddEventAlertBoxWidget(titleController: titleController),
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
            Consumer<TaskController>(builder: (context, taskController, _) {
              return CalendarWeek(
                controller: weekController,
                todayDateStyle: todayDateTextStyle,
                weekendsStyle: weekEndTextStyle,
                dayOfWeekStyle: const TextStyle(color: Colors.white),
                dateStyle: dateTextStyle,
                pressedDateBackgroundColor: Colors.white,
                pressedDateStyle: pressedDateTextStyle,
                backgroundColor: Colors.black12,
                height: 100,
                showMonth: true,
                minDate: DateTime.now().add(
                  const Duration(days: -365),
                ),
                maxDate: DateTime.now().add(
                  const Duration(days: 365),
                ),
                onDatePressed: (datetime) {
                  taskController.saveViewDate();
                  taskController.getSavedTasks();

                  taskController.viewDate =
                      '${datetime.day}/${datetime.month}/${datetime.year}';
                },
                onDateLongPressed: (DateTime datetime) {},
                onWeekChanged: () {},
                monthViewBuilder: (DateTime time) => Align(
                  alignment: FractionalOffset.center,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 171),
                    child: Text(
                      DateFormat.yMMMM().format(time),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
              );
            }),
            Expanded(
              child: Consumer<TaskController>(
                  builder: (context, taskController, _) {
                return ListView.separated(
                    itemBuilder: (BuildContext context, indexOfReminder) =>
                        ListTile(
                          title: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                color: Colors.lightBlue.shade50,
                                borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(10),
                                    left: Radius.circular(10))),
                            child: Center(
                              child: Text(
                                taskController.tasks[indexOfReminder]
                                    .toUpperCase(),
                                textAlign: TextAlign.start,
                                style: contentTextStyle,
                              ),
                            ),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                taskController
                                    .removeSavedTasks(indexOfReminder);
                              },
                              icon: const Icon(
                                Icons.remove_circle_outline_sharp,
                                color: Colors.red,
                              )),
                        ),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                          color: Colors.black,
                        ),
                    itemCount: taskController.tasks.length);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
