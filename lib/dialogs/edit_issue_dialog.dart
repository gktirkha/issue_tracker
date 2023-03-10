import 'package:brd_issue_tracker/dashboard/api/update_issue_api.dart';
import 'package:brd_issue_tracker/dialogs/assign_to_dialog.dart';
import 'package:brd_issue_tracker/shared/models/issues_model.dart';
import 'package:brd_issue_tracker/shared/utils/util_widgets.dart';
import 'package:brd_issue_tracker/shared/utils/static_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login/providers/auth_provider.dart';

Future<bool?> showEditDialog(BuildContext context, Issue selectedIssue) async {
  return showGeneralDialog<bool>(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      TextEditingController titleController = TextEditingController();
      TextEditingController descriptionController = TextEditingController();
      titleController.text = selectedIssue.title;
      descriptionController.text = selectedIssue.description;
      ValueNotifier<String> selectedPriorityValue =
          ValueNotifier(selectedIssue.priority);
      Size size = MediaQuery.of(context).size;
      String myId =
          Provider.of<AuthProvider>(context, listen: false).loggedInUser!.id;
      bool enableEditting = myId == selectedIssue.createdById;
      ValueNotifier<String> issueNotify =
          ValueNotifier(selectedIssue.assignedTo ?? "none");
      ValueNotifier<bool> isLoading = ValueNotifier(false);
      final String token =
          Provider.of<AuthProvider>(context).loggedInUser!.token!;
      final bool isCompleted = selectedIssue.status == COMPLETED;
      final formKey = GlobalKey<FormState>();

      Future<void> updateIssue() async {
        isLoading.value = true;
        if (!formKey.currentState!.validate()) {
          return;
        }
        await updateIssueService(
          description: descriptionController.text,
          id: selectedIssue.id,
          title: titleController.text,
          priority: selectedPriorityValue.value,
          token: token,
          assignToUser: selectedIssue.assignedToId,
        ).then((value) => refresh(context)).then(
              (value) => Navigator.pop(context),
            );
      }

      return Center(
        child: Container(
          width: size.width / 2,
          height: size.height / 2,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Form(
            key: formKey,
            child: Material(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Update Issue",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (!enableEditting)
                    const Text("The Issue Is Not Created By You"),
                  if (isCompleted)
                    const Text(
                      "Can not edit completed task",
                      style: TextStyle(color: Colors.red),
                    ),
                  TextFormField(
                    controller: titleController,
                    enabled: enableEditting,
                    decoration: const InputDecoration(labelText: "Title"),
                    validator: (value) {
                      if (value == null) {
                        return "please input title";
                      }
                      if (value.isEmpty || value.length < 5) {
                        return "Minimum Length Should Be 5";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descriptionController,
                    enabled: enableEditting && !isCompleted,
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (value) {
                      if (value == null) {
                        return "please input title";
                      }
                      if (value.isEmpty || value.length < 5) {
                        return "Minimum Length Should Be 5";
                      }
                      return null;
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: selectedPriorityValue,
                    builder: (context, dropValue, child) => SizedBox(
                      width: MediaQuery.of(context).size.width * .2,
                      child: DropdownButton(
                          isExpanded: true,
                          value: dropValue,
                          items: priorityList
                              .map<DropdownMenuItem<String>>(
                                  (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                              .toList(),
                          onChanged: enableEditting && !isCompleted
                              ? (String? value) {
                                  selectedPriorityValue.value =
                                      value ?? selectedPriorityValue.value;
                                }
                              : null),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: issueNotify,
                    builder: (context, issue, child) => Row(
                      children: [
                        Text("Assigned To : $issue"),
                        TextButton(
                          onPressed: !isCompleted
                              ? () async {
                                  await showAssignDialog(context).then(
                                    (selVal) {
                                      if (selVal != null) {
                                        selectedIssue.assignedToId =
                                            selVal["id"];
                                        selectedIssue.assignedTo =
                                            selVal["name"];
                                        issueNotify.value =
                                            selectedIssue.assignedTo ?? "none";
                                      }
                                    },
                                  );
                                }
                              : null,
                          child: const Text("Change"),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ValueListenableBuilder(
                    valueListenable: isLoading,
                    builder: (context, value, child) => Row(
                      children: [
                        const Spacer(),
                        TextButton(
                            onPressed: value
                                ? null
                                : () async {
                                    await updateIssue();
                                  },
                            child: const Text("Save")),
                        TextButton(
                            onPressed: !isCompleted
                                ? () {
                                    Navigator.pop(context);
                                  }
                                : null,
                            child: const Text("Discard"))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(0, .1), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(0, -.1), end: Offset.zero);
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
