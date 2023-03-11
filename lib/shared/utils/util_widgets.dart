import 'package:brd_issue_tracker/dashboard/api/assign_issue_api.dart';

import 'package:brd_issue_tracker/dashboard/api/update_status_api.dart';
import 'package:brd_issue_tracker/dialogs/delete_issue_dialog.dart';
import 'package:brd_issue_tracker/dialogs/edit_issue_dialog.dart';
import 'package:brd_issue_tracker/dialogs/edit_user_dialog.dart';
import 'package:brd_issue_tracker/dialogs/show_delete_user_dialog.dart';
import 'package:brd_issue_tracker/dialogs/show_description_dialog.dart';
import 'package:brd_issue_tracker/login/api/check_auth_token.dart';
import 'package:brd_issue_tracker/login/providers/auth_provider.dart';
import 'package:brd_issue_tracker/shared/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dashboard/provider/all_issue_provider.dart';
import '../../dashboard/provider/all_user_provider.dart';
import '../../dashboard/provider/area_chart_provider.dart';
import '../../dashboard/provider/donut_chart_provider.dart';
import '../../dashboard/provider/issues_assigned_to_me_provider.dart';
import '../../dashboard/provider/issues_created_by_me_provider.dart';
import '../../dialogs/assign_to_dialog.dart';
import 'static_data.dart';
import '../models/issues_model.dart';

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
                  loadingBool.value = true;
                  await showEditDialog(context, issue).then(
                    (value) => loadingBool.value = false,
                  );
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
    final String token =
        Provider.of<AuthProvider>(context, listen: false).loggedInUser!.token!;
    return ValueListenableBuilder(
      valueListenable: loadingBool,
      builder: (context, value, child) {
        return TextButton(
          onPressed: value
              ? null
              : () async {
                  loadingBool.value = true;
                  await showDeleteIssueDialog(context, issue, token)
                      .then((value) => loadingBool.value = false);
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
    final String token =
        Provider.of<AuthProvider>(context, listen: false).loggedInUser!.token!;
    return ValueListenableBuilder(
      valueListenable: loadingBool,
      builder: (context, value, child) {
        return TextButton(
          onPressed: value
              ? null
              : () async {
                  loadingBool.value = true;
                  try {
                    await showAssignDialog(context).then(
                      (value) async {
                        if (value["id"] != null) {
                          await assignIssue(
                            authToken: token,
                            issueID: issue.id,
                            userID: value["id"],
                          );
                        }
                      },
                    ).then((value) {
                      refresh(context);
                    });
                  } finally {
                    loadingBool.value = false;
                  }
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
    final String token =
        Provider.of<AuthProvider>(context, listen: false).loggedInUser!.token!;
    return ValueListenableBuilder(
      valueListenable: loadingBool,
      builder: (context, value, child) {
        return PopupMenuButton<String>(
          child: TextButton(
            onPressed: null,
            style: TextButton.styleFrom(
                disabledForegroundColor: Colors.deepOrange),
            child: const Text("Update Status"),
          ),
          onSelected: (value) async {
            await updateStatusService(issue.id, value, token).then(
              (value) => refresh(context),
            );
          },
          itemBuilder: (context) => [
            ...statusList.map(
              (e) => PopupMenuItem(
                value: e,
                child: Text(e),
              ),
            ),
          ],
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
    final UserModel user =
        Provider.of<AuthProvider>(context, listen: false).loggedInUser!;
    return ValueListenableBuilder(
      valueListenable: loadingBool,
      builder: (context, value, child) {
        return TextButton(
          onPressed: value
              ? null
              : () async {
                  loadingBool.value = true;
                  try {
                    await assignIssue(
                            issueID: issue.id,
                            userID: user.id,
                            authToken: user.token!)
                        .then((value) => refresh(context));
                  } finally {
                    loadingBool.value = false;
                  }
                },
          child: const Text("Assign To Me"),
        );
      },
    );
  }
}

Future<void> refresh(BuildContext context) async {
  String authToken =
      Provider.of<AuthProvider>(context, listen: false).loggedInUser!.token!;

  Provider.of<AreaChartProvider>(context, listen: false);
  Provider.of<DonutChartProvider>(context, listen: false)
      .getDonutData(authToken);
  Provider.of<IssuesCreatedByMeProvider>(context, listen: false)
      .getMyIssues(authToken);
  Provider.of<AllIssuesProvider>(context, listen: false)
      .getAllIssues(authToken);
  Provider.of<AllUserProvider>(context, listen: false).getAllUsers(authToken);
  Provider.of<IssuesAssignedToMeProvider>(context, listen: false)
      .getIssuesAssignedToMe(authToken);
  Provider.of<AreaChartProvider>(context, listen: false).getAreaData(authToken);

  await tokenValidationService(token: authToken).then(
    (value) async {
      if (value != true) {
        await Provider.of<AuthProvider>(context, listen: false)
            .logout()
            .then((value) {
          Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        });
      }
    },
  );
}

class CustomDeleteUserButton extends StatelessWidget {
  const CustomDeleteUserButton({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final String token =
        Provider.of<AuthProvider>(context, listen: false).loggedInUser!.token!;
    return TextButton(
        onPressed: () async {
          await showDeleteUserDialog(context, user, token);
        },
        child: const Text("Delete"));
  }
}

class AdminBox extends StatelessWidget {
  const AdminBox({
    super.key,
    required this.isAdmin,
  });
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isAdmin ? Colors.green : Colors.yellow),
      child: Center(
        child: Text(
          isAdmin ? "admin" : "not Admin",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class YouBox extends StatelessWidget {
  const YouBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.blue),
      child: const Center(
        child: Text(
          "You",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class CustomEditUserButton extends StatelessWidget {
  const CustomEditUserButton({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await showEditUserDialog(context, user);
      },
      child: const Text("edit"),
    );
  }
}
