import 'package:brd_issue_tracker/dashboard/widgets/dialogs/edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../shared/util.dart';
import '../../../shared/util_widgets.dart';
import '../../../static_data.dart';
import '../../provider/issues_assigned_to_me_provider.dart';

class IssuesAssignedToMe extends StatefulWidget {
  const IssuesAssignedToMe({super.key, required this.authToken});
  final String authToken;

  @override
  State<IssuesAssignedToMe> createState() => _IssuesAssignedToMeState();
}

class _IssuesAssignedToMeState extends State<IssuesAssignedToMe> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<IssuesAssignedToMeProvider>(context, listen: false)
          .getIssuesAssignedToMe(widget.authToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<IssuesAssignedToMeProvider>(
        builder: (context, value, child) => value.isLoading
            ? const SpinKitFadingCube(color: Colors.deepOrange, size: 50)
            : Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Issues assigned to me ",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
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
                                  color:
                                      const Color.fromARGB(255, 244, 246, 247),
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
                                              padding: const EdgeInsets.all(8),
                                              color: priorityColor(value
                                                  .myIssuesList[index]
                                                  .priority),
                                              child: Center(
                                                child: Text(
                                                    value.myIssuesList[index]
                                                        .priority,
                                                    style: const TextStyle(
                                                        color: Colors.white)),
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
                                          Text(value
                                              .myIssuesList[index].description),
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
                                                  text: getIssueDayString(value
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
                                                  text: getIssueDayString(value
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
                                              Text(value
                                                  .myIssuesList[index].status),
                                              Spacer(),
                                              TextButton(
                                                onPressed: () {
                                                  showEditDialog(
                                                      context,
                                                      value
                                                          .myIssuesList[index]);
                                                },
                                                style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.deepOrange),
                                                child: const Text(
                                                  "Edit",
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.deepOrange),
                                                child: const Text(
                                                  "Assign To Other",
                                                ),
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
                      separatorBuilder: (context, index) => vSizedBoxSmall()),
                ],
              ),
      ),
    );
  }
}
