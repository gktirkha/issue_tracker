import 'package:brd_issue_tracker/dashboard/widgets/dialogs/assign_to_dialog.dart';
import 'package:brd_issue_tracker/shared/models/issues_model.dart';
import 'package:brd_issue_tracker/static_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../login/providers/auth_provider.dart';

Future<bool?> showEditDialog(BuildContext context, Issue selectedIssue) async {
  return showGeneralDialog<bool>(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      bool isAssigned = selectedIssue.assignedTo != null;
      TextEditingController titleController = TextEditingController();
      TextEditingController decriptionController = TextEditingController();
      titleController.text = selectedIssue.title;
      decriptionController.text = selectedIssue.description;
      ValueNotifier<String> selectedPriorityValue =
          ValueNotifier(selectedIssue.priority);
      ValueNotifier<String> statusValue = ValueNotifier(selectedIssue.status);
      Size size = MediaQuery.of(context).size;
      String myId =
          Provider.of<AuthProvider>(context, listen: false).loggedInUser!.id;
      bool enableEditting = myId == selectedIssue.createdById;
      bool enableStatus = myId == selectedIssue.assignedToId;
      ValueNotifier<String> issueNotify =
          ValueNotifier(selectedIssue.assignedTo ?? "none");

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
                Text(
                  "Update Issue",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (!enableEditting) Text("The Issue Is Not Created By You"),
                TextField(controller: titleController, enabled: enableEditting),
                TextField(
                  controller: decriptionController,
                  enabled: enableEditting,
                ),
                ValueListenableBuilder(
                  valueListenable: selectedPriorityValue,
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
                        onChanged: enableEditting
                            ? (String? value) {
                                selectedPriorityValue.value =
                                    value ?? selectedPriorityValue.value;
                              }
                            : null),
                  ),
                ),
                // if (isAssigned)
                //   ValueListenableBuilder(
                //     valueListenable: statusValue,
                //     builder: (context, dropValue, child) => Container(
                //       width: MediaQuery.of(context).size.width * .2,
                //       child: DropdownButton(
                //           isExpanded: true,
                //           value: dropValue,
                //           items: statusList
                //               .map<DropdownMenuItem<String>>(
                //                   (e) => DropdownMenuItem(
                //                         child: Text(e),
                //                         value: e,
                //                       ))
                //               .toList(),
                //           onChanged: enableStatus
                //               ? (String? value) {
                //                   statusValue.value =
                //                       value ?? statusValue.value;
                //                 }
                //               : null),
                //     ),
                //   ),
                ValueListenableBuilder(
                  valueListenable: issueNotify,
                  builder: (context, issue, child) => Row(
                    children: [
                      Text("Assigned To : $issue"),
                      TextButton(
                        onPressed: () async {
                          await showAssignDialog(context).then(
                            (selVal) {
                              selectedIssue.assignedToId = selVal["id"];
                              selectedIssue.assignedTo = selVal["name"];

                              issueNotify.value = selectedIssue.assignedTo!;
                            },
                          );
                        },
                        child: Text("Change"),
                      ),
                    ],
                  ),
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
