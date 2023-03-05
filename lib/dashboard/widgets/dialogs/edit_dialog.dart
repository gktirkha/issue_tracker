import 'package:brd_issue_tracker/shared/models/issues_model.dart';
import 'package:brd_issue_tracker/static_data.dart';
import 'package:flutter/material.dart';
import '../../../shared/util_widgets.dart';

Future<bool?> showEditDialog(BuildContext context, Issue selectedIssue) async {
  return showGeneralDialog<bool>(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      TextEditingController titleController = TextEditingController();
      TextEditingController decriptionController = TextEditingController();
      titleController.text = selectedIssue.title;
      decriptionController.text = selectedIssue.description;
      ValueNotifier<String> selectedValue =
          ValueNotifier(selectedIssue.priority);
      Size size = MediaQuery.of(context).size;

      return Center(
        child: Container(
          width: size.width / 2,
          height: size.height / 2,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Material(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(controller: titleController),
                TextField(controller: decriptionController),
                Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: selectedValue,
                      builder: (context, dropValue, child) => Container(
                        width: MediaQuery.of(context).size.width * .2,
                        child: DropdownButton(
                          isExpanded: true,
                          value: dropValue,
                          items: priorityList
                              .map<DropdownMenuItem<String>>(
                                  (e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                              .toList(),
                          onChanged: (value) => selectedValue.value =
                              value ?? selectedValue.value,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Spacer(),
                    TextButton(onPressed: () {}, child: Text("Save")),
                    TextButton(onPressed: () {}, child: Text("Discard"))
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: Offset(0, .1), end: Offset.zero);
      } else {
        tween = Tween(begin: Offset(0, -.1), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}
