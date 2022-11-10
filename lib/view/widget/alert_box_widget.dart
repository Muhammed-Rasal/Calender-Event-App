import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Controller/SharedPrefrence_Controller.dart';
import '../../utilities/theme/text_styles.dart';

class AddEventAlertBoxWidget extends StatelessWidget {
  const AddEventAlertBoxWidget({
    super.key,
    required this.titleController,
  });

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black87,
      insetPadding: EdgeInsets.zero,
      contentTextStyle: GoogleFonts.mulish(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'ADD REMINDER',
        style: headingTextStyle,
      ),
      content: SizedBox(
        height: 74,
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: textFiledTextStyle,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
                hintText: 'Title',
                hintStyle: textFiledTextStyle,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
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
        Consumer<TaskController>(builder: (context, taskController, _) {
          return TextButton(
            onPressed: () {
              taskController.saveViewDate();
              taskController.saveTasks();
              taskController.tasks.add(titleController.text);
              titleController.clear();
              Navigator.of(context).pop();
            },
            child: const Text(
              'ADD',
              style: TextStyle(color: Colors.red),
            ),
          );
        }),
      ],
    );
  }
}
