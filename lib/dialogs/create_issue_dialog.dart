import 'assign_to_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/utils/static_data.dart';
import '../shared/utils/util_widgets.dart';
import '../login/providers/auth_provider.dart';
import '../dashboard/api/create_issue_api.dart';


Future<bool?> showCreateDialog(BuildContext context) async {
  return showGeneralDialog<bool>(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      TextEditingController titleController = TextEditingController();
      TextEditingController descriptionController = TextEditingController();
      ValueNotifier<String> createdPriorityValue = ValueNotifier(LOW_PRIORITY);
      Size size = MediaQuery.of(context).size;
      ValueNotifier<String> assignedTo = ValueNotifier("none");
      ValueNotifier<bool> isLoading = ValueNotifier(false);
      final String token =
          Provider.of<AuthProvider>(context).loggedInUser!.token!;
      String? assignToId;
      final formKey = GlobalKey<FormState>();
      Future<void> createIssue() async {
        if (!formKey.currentState!.validate()) {
          return;
        }
        isLoading.value = true;
        await createIssueService(
          token: token,
          title: titleController.text,
          description: descriptionController.text,
          priority: createdPriorityValue.value,
          assignToId: assignToId,
        ).then(
          (value) {
            if (value == true) {
              refresh(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Issue Created Sucesfully"),
                ),
              );
            }
          },
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
                    "Create Issue",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextFormField(
                    controller: titleController,
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
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (value) {
                      if (value == null) {
                        return "please input description";
                      }
                      if (value.isEmpty || value.length < 5) {
                        return "Minimum Length Should Be 5";
                      }
                      return null;
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: createdPriorityValue,
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
                          onChanged: (String? value) {
                            createdPriorityValue.value =
                                value ?? createdPriorityValue.value;
                          }),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: assignedTo,
                    builder: (context, issue, child) => Row(
                      children: [
                        Text("Assigned To : $issue"),
                        TextButton(
                          onPressed: () async {
                            try {
                              await showAssignDialog(context).then(
                                (value) {
                                  if (value != null &&
                                      value["name"] != null &&
                                      value["id"] != null) {
                                    assignedTo.value = value["name"];
                                    assignToId = value["id"];
                                  }
                                },
                              );
                            } finally {}
                          },
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
                                    await createIssue();
                                  },
                            child: const Text("Save")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
