import 'package:brd_issue_tracker/dashboard/api/assign_issue_api.dart';
import 'package:brd_issue_tracker/dashboard/api/my_issue_list_api.dart';
import 'package:brd_issue_tracker/dashboard/api/update_status_api.dart';
import 'package:brd_issue_tracker/dashboard/widgets/dialogs/delete_dialog.dart';
import 'package:brd_issue_tracker/dashboard/widgets/dialogs/edit_dialog.dart';
import 'package:brd_issue_tracker/dashboard/widgets/dialogs/show_description_dialog.dart';
import 'package:brd_issue_tracker/login/providers/auth_provider.dart';
import 'package:brd_issue_tracker/shared/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dashboard/provider/all_issue_provider.dart';
import '../dashboard/provider/all_user_provider.dart';
import '../dashboard/provider/area_chart_provider.dart';
import '../dashboard/provider/donut_chart_provider.dart';
import '../dashboard/provider/issues_assigned_to_me_provider.dart';
import '../dashboard/provider/my_issue_provider.dart';
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
                  await showDeleteDialog(context)
                      .then((value) {
                        if (value == true) {
                          deleteIssueService(
                              issueId: issue.id, authToken: token);
                        }
                      })
                      .then(
                        (value) => loadingBool.value = false,
                      )
                      .then((value) => refresh(context));
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
                      (value) {
                        if (value["id"] != null) {
                          assignIssue(
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
          onSelected: (value) async {
            await updateStatusService(issue.id, value, token).then(
              (value) => refresh(context),
            );
          },
          child: Text(
            "Update Status",
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500),
          ),
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
  Provider.of<MyIssuesProvider>(context, listen: false).getMyIssues(authToken);
  Provider.of<AllIssuesProvider>(context, listen: false)
      .getAllIssues(authToken);
  Provider.of<AllUserProvider>(context, listen: false).getAllUsers(authToken);
  Provider.of<IssuesAssignedToMeProvider>(context, listen: false)
      .getIssuesAssignedToMe(authToken);
  Provider.of<AreaChartProvider>(context, listen: false).getAreaData(authToken);
}

class CustomDeleteUserButton extends StatelessWidget {
  const CustomDeleteUserButton({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () {}, child: Text("Delete"));
  }
}
