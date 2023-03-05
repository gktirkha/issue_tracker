import 'package:brd_issue_tracker/dashboard/widgets/dialogs/edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../shared/util.dart';
import '../../../shared/util_widgets.dart';
import '../../../static_data.dart';
import '../../provider/my_issue_provider.dart';
import '../dialogs/delete_dialog.dart';

class MyIssues extends StatefulWidget {
  const MyIssues({super.key, required this.authToken});
  final String authToken;

  @override
  State<MyIssues> createState() => _MyIssuesState();
}

class _MyIssuesState extends State<MyIssues> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<MyIssuesProvider>(
        builder: (context, value, child) => value.isLoading
            ? const SpinKitFadingCube(color: Colors.deepOrange, size: 50)
            : value.isError
                ? const Text("server Error")
                : value.myIssuesList.isEmpty
                    ? const Text("No Issues")
                    : Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "My Issues",
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                          ),
                          vSizedBoxSmall(),
                          ListView.separated(
                            shrinkWrap: true,
                            itemCount: value.myIssuesList.length,
                            itemBuilder: (context, index) => LayoutBuilder(
                              // key: ValueKey(value.myIssuesList[index].id),
                              builder: (context, constraints) {
                                ValueNotifier<bool> isExpanded =
                                    ValueNotifier(false);
                                return ValueListenableBuilder(
                                  valueListenable: isExpanded,
                                  builder: (context, isExpandedBool, child) =>
                                      AnimatedContainer(
                                    duration: const Duration(microseconds: 200),
                                    color: const Color.fromARGB(
                                        255, 244, 246, 247),
                                    child: Container(
                                      margin: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            value.myIssuesList[index].title
                                                .toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          vSizedBoxSmall(),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                color: priorityColor(value
                                                    .myIssuesList[index]
                                                    .priority),
                                                child: Center(
                                                  child: Text(
                                                    value.myIssuesList[index]
                                                        .priority,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () {
                                                  isExpanded.value =
                                                      !isExpandedBool;
                                                },
                                                icon: Icon(!isExpandedBool
                                                    ? Icons
                                                        .arrow_drop_down_circle_outlined
                                                    : Icons
                                                        .keyboard_arrow_up_sharp),
                                              )
                                            ],
                                          ),
                                          if (isExpandedBool) vSizedBoxSmall(),
                                          if (isExpandedBool)
                                            Text(value.myIssuesList[index]
                                                .description),
                                          if (isExpandedBool) vSizedBoxSmall(),
                                          if (isExpandedBool)
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
                                                        value
                                                            .myIssuesList[index]
                                                            .createdAt),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (isExpandedBool)
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
                                                        value
                                                            .myIssuesList[index]
                                                            .updatedAt),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (isExpandedBool)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  value.myIssuesList[index]
                                                      .status,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                                const Spacer(),
                                                TextButton(
                                                  onPressed: () async {
                                                    await showEditDialog(
                                                      context,
                                                      value.myIssuesList[index],
                                                    );
                                                  },
                                                  style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.deepOrange),
                                                  child: const Text("Edit"),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await showEditDialog(
                                                      context,
                                                      value.myIssuesList[index],
                                                    );
                                                  },
                                                  style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.deepOrange),
                                                  child: const Text(
                                                      "Assign To Me"),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await showDeleteDialog(
                                                            context)
                                                        .then(
                                                      (dialogBool) async {
                                                        if (dialogBool !=
                                                                null &&
                                                            dialogBool ==
                                                                true) {
                                                          await value
                                                              .deleteIssue(
                                                                  issueId: value
                                                                      .myIssuesList[
                                                                          index]
                                                                      .id,
                                                                  authToken: widget
                                                                      .authToken)
                                                              .then(
                                                                (_) => value
                                                                    .getMyIssues(
                                                                        widget
                                                                            .authToken),
                                                              );
                                                        }
                                                      },
                                                    );
                                                  },
                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            separatorBuilder: (context, index) =>
                                vSizedBoxSmall(),
                          ),
                        ],
                      ),
      ),
    );
  }
}
