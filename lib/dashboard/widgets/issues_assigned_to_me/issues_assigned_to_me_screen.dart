import 'package:brd_issue_tracker/dashboard/provider/issues_assigned_to_me_provider.dart';
import 'package:brd_issue_tracker/login/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../shared/util.dart';
import '../../../shared/util_widgets.dart';
import '../../../static_data.dart';

class AssignedIssueHome extends StatefulWidget {
  const AssignedIssueHome(
      {super.key, required this.authToken, required this.safesize});
  final String authToken;
  final Size safesize;

  @override
  State<AssignedIssueHome> createState() => _AssignedIssueHomeState();
}

class _AssignedIssueHomeState extends State<AssignedIssueHome> {
  double myPadding = 16;
  ValueNotifier<bool> isExpanded = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    String myId =
        Provider.of<AuthProvider>(context, listen: false).loggedInUser!.id;

    return Container(
      height: widget.safesize.height * .90,
      width: widget.safesize.width * .90,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Consumer<IssuesAssignedToMeProvider>(
        builder: (context, assignedToMeProvider, child) => Stack(
          children: [
            Container(
              child: assignedToMeProvider.isLoading
                  ? const Center(
                      child: SpinKitFadingCube(color: Colors.deepOrange),
                    )
                  : assignedToMeProvider.isError
                      ? const Center(child: Text("Error Occured"))
                      : ListView.separated(
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(myPadding),
                              color: const Color.fromARGB(255, 244, 246, 247),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          assignedToMeProvider
                                              .issuesAssignedToMeList[index]
                                              .title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                      hSizedBoxMedium(),
                                      PriorityBox(
                                        value: assignedToMeProvider
                                            .issuesAssignedToMeList[index]
                                            .priority,
                                      ),
                                    ],
                                  ),
                                  vSizedBoxSmall(),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: widget.safesize.width * .18,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: "Created By: ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text: assignedToMeProvider
                                                        .issuesAssignedToMeList[
                                                            index]
                                                        .createdBy,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: "Created : ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text: getIssueDayString(
                                                        assignedToMeProvider
                                                            .issuesAssignedToMeList[
                                                                index]
                                                            .createdAt),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: "Last Updated : ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: getIssueDayString(
                                                      assignedToMeProvider
                                                          .issuesAssignedToMeList[
                                                              index]
                                                          .updatedAt),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: "Status : ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: assignedToMeProvider
                                                      .issuesAssignedToMeList[
                                                          index]
                                                      .status,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      CustomViewIssueButton(
                                        issue: assignedToMeProvider
                                            .issuesAssignedToMeList[index],
                                      ),
                                      CustomUpdateStatusButton(
                                        issue: assignedToMeProvider
                                            .issuesAssignedToMeList[index],
                                      ),
                                      if (assignedToMeProvider
                                              .issuesAssignedToMeList[index]
                                              .createdById ==
                                          myId)
                                        CustomEditButton(
                                          issue: assignedToMeProvider
                                              .issuesAssignedToMeList[index],
                                        ),
                                      if (assignedToMeProvider
                                              .issuesAssignedToMeList[index]
                                              .status !=
                                          COMPLETED)
                                        CustomAssignToOtherButton(
                                          issue: assignedToMeProvider
                                              .issuesAssignedToMeList[index],
                                        ),
                                      SizedBox(
                                          width: widget.safesize.width * .03)
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemCount: assignedToMeProvider
                              .issuesAssignedToMeList.length,
                        ),
            ),
            ValueListenableBuilder(
              valueListenable: isExpanded,
              builder: (context, value, child) {
                return Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        tooltip: "sort",
                        onPressed: () {
                          isExpanded.value = !value;
                        },
                        child: Icon(Icons.sort),
                      ),
                      if (value) const SizedBox(height: 10),
                      if (value)
                        FloatingActionButton(
                          tooltip: "Sort By Date",
                          onPressed: () {
                            assignedToMeProvider.sortIssuesByCreationDate();
                          },
                          child: Icon(Icons.calendar_month),
                        ),
                      if (value) const SizedBox(height: 10),
                      if (value)
                        FloatingActionButton(
                          tooltip: "Sort By Priority",
                          onPressed: () {
                            assignedToMeProvider.sortIssuesByPriority();
                          },
                          child: Icon(Icons.low_priority),
                        ),
                      if (value) const SizedBox(height: 10),
                      if (value)
                        FloatingActionButton(
                          tooltip: "Sort By Updated",
                          onPressed: () {
                            assignedToMeProvider.sortIssuesByUpdateDate();
                          },
                          child: Icon(Icons.calendar_view_day_rounded),
                        ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
