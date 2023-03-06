import 'package:brd_issue_tracker/dashboard/widgets/dialogs/delete_dialog.dart';
import 'package:brd_issue_tracker/dashboard/widgets/dialogs/edit_dialog.dart';
import 'package:brd_issue_tracker/dashboard/widgets/dialogs/show_description_dialog.dart';
import 'package:flutter/material.dart';

import '../dashboard/widgets/dialogs/assign_to_dialog.dart';
import '../static_data.dart';
import 'models/issues_model.dart';

Widget vSizedBoxSmall() {
  return const SizedBox(
    height: 10,
  );
}

Widget vSizedBoxMedium() {
  return const SizedBox(
    height: 20,
  );
}

Widget vSizedBoxLarge() {
  return const SizedBox(
    height: 30,
  );
}

Widget hSizedBoxSmall() {
  return const SizedBox(
    width: 10,
  );
}

Widget hSizedBoxMedium() {
  return const SizedBox(
    width: 15,
  );
}

Widget hSizedBoxLarge() {
  return const SizedBox(
    width: 20,
  );
}

class PriorityBox extends StatelessWidget {
  const PriorityBox({
    super.key,
    required this.value,
  });
  final String value;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: priorityColor(value),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class StatusBox extends StatelessWidget {
  const StatusBox({
    super.key,
    required this.status,
  });
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          color: statusColor(status), borderRadius: BorderRadius.circular(8)),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CustomEditButton extends StatelessWidget {
  CustomEditButton({super.key, required this.issue});
  final ValueNotifier<bool> loadingBool = ValueNotifier(false);
  final Issue issue;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: loadingBool,
      builder: (context, value, child) {
        return TextButton(
          onPressed: value
              ? null
              : () async {
                  await showEditDialog(context, issue);
                },
          child: const Text("Edit"),
        );
      },
    );
  }
}

class CustomDeleteButton extends StatelessWidget {
  CustomDeleteButton({super.key, required this.issue});
  final ValueNotifier<bool> loadingBool = ValueNotifier(false);
  final Issue issue;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: loadingBool,
      builder: (context, value, child) {
        return TextButton(
          onPressed: value
              ? null
              : () async {
                  await showDeleteDialog(context);
                },
          child: const Text("Delete"),
        );
      },
    );
  }
}

class CustomAssignToOtherButton extends StatelessWidget {
  CustomAssignToOtherButton({super.key, required this.issue});
  final ValueNotifier<bool> loadingBool = ValueNotifier(false);
  final Issue issue;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: loadingBool,
      builder: (context, value, child) {
        return TextButton(
          onPressed: value
              ? null
              : () async {
                  await showAssignDialog(context);
                },
          child: const Text("Assign To Other"),
        );
      },
    );
  }
}

class CustomUpdateStatusButton extends StatelessWidget {
  CustomUpdateStatusButton({super.key, required this.issue});
  final ValueNotifier<bool> loadingBool = ValueNotifier(false);
  final Issue issue;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: loadingBool,
      builder: (context, value, child) {
        return TextButton(
          onPressed: value ? null : () async {},
          child: const Text("Update Status"),
        );
      },
    );
  }
}

class CustomViewIssueButton extends StatelessWidget {
  CustomViewIssueButton({super.key, required this.issue});
  final ValueNotifier<bool> loadingBool = ValueNotifier(false);
  final Issue issue;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: loadingBool,
      builder: (context, value, child) {
        return TextButton(
          onPressed: value
              ? null
              : () async {
                  await showDescriptionDialog(context, issue);
                },
          child: const Text("View"),
        );
      },
    );
  }
}

class CustomAssignToMeButton extends StatelessWidget {
  CustomAssignToMeButton({super.key, required this.issue});
  final ValueNotifier<bool> loadingBool = ValueNotifier(false);
  final Issue issue;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: loadingBool,
      builder: (context, value, child) {
        return TextButton(
          onPressed: value
              ? null
              : () async {
                  await showDescriptionDialog(context, issue);
                },
          child: const Text("Assign To Me"),
        );
      },
    );
  }
}
