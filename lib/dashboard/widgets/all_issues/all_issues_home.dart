import 'package:brd_issue_tracker/dashboard/provider/all_issue_provider.dart';
import 'package:brd_issue_tracker/static_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../login/providers/auth_provider.dart';
import '../../../shared/util.dart';
import '../../../shared/util_widgets.dart';

class AllIssuesHome extends StatefulWidget {
  const AllIssuesHome(
      {super.key, required this.authToken, required this.safesize});
  final String authToken;
  final Size safesize;

  @override
  State<AllIssuesHome> createState() => _AllIssuesHomeState();
}

class _AllIssuesHomeState extends State<AllIssuesHome> {
  double myPadding = 16;
  ValueNotifier<bool> isExpanded = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    String myId =
        Provider.of<AuthProvider>(context, listen: false).loggedInUser!.id;

    return Container(
      height: widget.safesize.height * .90,
      width: widget.safesize.width * .90,
      padding: EdgeInsets.all(myPadding),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Consumer<AllIssuesProvider>(
        builder: (context, allIssueProvider, child) => Stack(
          children: [
            Container(
              child: allIssueProvider.isLoading
                  ? const SpinKitFadingCube(color: Colors.deepOrange)
                  : allIssueProvider.isError
                      ? const Text("Error")
                      : allIssueProvider.allIssuesList.isEmpty
                          ? const Text("No Issues")
                          : ListView.separated(
                              itemBuilder: (context, index) => Container(
                                    padding: EdgeInsets.all(myPadding),
                                    color: const Color.fromARGB(
                                        255, 244, 246, 247),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                allIssueProvider
                                                    .allIssuesList[index].title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge),
                                            hSizedBoxMedium(),
                                            PriorityBox(
                                              value: allIssueProvider
                                                  .allIssuesList[index]
                                                  .priority,
                                            ),
                                          ],
                                        ),
                                        vSizedBoxSmall(),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width:
                                                  widget.safesize.width * .18,
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
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        TextSpan(
                                                          text: allIssueProvider
                                                              .allIssuesList[
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
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        TextSpan(
                                                          text: getIssueDayString(
                                                              allIssueProvider
                                                                  .allIssuesList[
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: "Status : ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      TextSpan(
                                                          text: allIssueProvider
                                                              .allIssuesList[
                                                                  index]
                                                              .status),
                                                    ],
                                                  ),
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: "Last Updated : ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      TextSpan(
                                                        text: getIssueDayString(
                                                            allIssueProvider
                                                                .allIssuesList[
                                                                    index]
                                                                .updatedAt),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            hSizedBoxLarge(),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: "Assigned To : ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text: allIssueProvider
                                                            .allIssuesList[
                                                                index]
                                                            .assignedTo ??
                                                        "None",
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            CustomViewIssueButton(
                                              issue: allIssueProvider
                                                  .allIssuesList[index],
                                            ),
                                            if (allIssueProvider
                                                    .allIssuesList[index]
                                                    .createdById ==
                                                myId)
                                              CustomEditButton(
                                                issue: allIssueProvider
                                                    .allIssuesList[index],
                                              ),
                                            if (allIssueProvider
                                                    .allIssuesList[index]
                                                    .createdById ==
                                                myId)
                                              CustomDeleteButton(
                                                issue: allIssueProvider
                                                    .allIssuesList[index],
                                              ),
                                            if (allIssueProvider
                                                    .allIssuesList[index]
                                                    .assignedToId ==
                                                myId)
                                              CustomUpdateStatusButton(
                                                issue: allIssueProvider
                                                    .allIssuesList[index],
                                              ),
                                            if (allIssueProvider
                                                    .allIssuesList[index]
                                                    .assignedToId !=
                                                myId)
                                              if (allIssueProvider
                                                      .allIssuesList[index]
                                                      .status !=
                                                  COMPLETED)
                                                CustomAssignToMeButton(
                                                  issue: allIssueProvider
                                                      .allIssuesList[index],
                                                ),
                                            if (allIssueProvider
                                                    .allIssuesList[index]
                                                    .status !=
                                                COMPLETED)
                                              if (allIssueProvider
                                                      .allIssuesList[index]
                                                      .createdById !=
                                                  myId)
                                                CustomAssignToOtherButton(
                                                  issue: allIssueProvider
                                                      .allIssuesList[index],
                                                ),
                                            SizedBox(
                                                width:
                                                    widget.safesize.width * .03)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                              separatorBuilder: (context, index) =>
                                  vSizedBoxMedium(),
                              itemCount: allIssueProvider.allIssuesList.length),
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
                        child: const Icon(Icons.sort),
                      ),
                      if (value) const SizedBox(height: 10),
                      if (value)
                        FloatingActionButton(
                          tooltip: "Sort By Date",
                          onPressed: () {
                            allIssueProvider.sortIssuesByCreationDate();
                          },
                          child: const Icon(Icons.calendar_month),
                        ),
                      if (value) const SizedBox(height: 10),
                      if (value)
                        FloatingActionButton(
                          tooltip: "Sort By Priority",
                          onPressed: () {
                            allIssueProvider.sortIssuesByPriority();
                          },
                          child: const Icon(Icons.low_priority),
                        ),
                      if (value) const SizedBox(height: 10),
                      if (value)
                        FloatingActionButton(
                          tooltip: "Sort By Updated",
                          onPressed: () {
                            allIssueProvider.sortIssuesByUpdateDate();
                          },
                          child: const Icon(Icons.calendar_view_day_rounded),
                        ),
                      if (value) const SizedBox(height: 10),
                      if (value)
                        FloatingActionButton(
                          tooltip: "Sort By Status",
                          onPressed: () {
                            allIssueProvider.sortIssuesByStatus();
                          },
                          child: const Icon(Icons.query_stats_outlined),
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
