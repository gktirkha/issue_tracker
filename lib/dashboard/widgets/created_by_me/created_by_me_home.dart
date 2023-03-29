import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/utils/util_methods.dart';
import '../../../shared/utils/util_widgets.dart';
import '../../../login/providers/auth_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../provider/issues_created_by_me_provider.dart';

class MyIssueHome extends StatefulWidget {
  const MyIssueHome(
      {super.key, required this.authToken, required this.safesize});
  final String authToken;
  final Size safesize;

  @override
  State<MyIssueHome> createState() => _MyIssueHomeState();
}

class _MyIssueHomeState extends State<MyIssueHome> {
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
      child: Consumer<IssuesCreatedByMeProvider>(
        builder: (context, issueCreatedByMeProvider, child) => Stack(
          children: [
            Container(
              child: issueCreatedByMeProvider.isLoading
                  ? const Center(
                      child: SpinKitFadingCube(color: Colors.deepOrange))
                  : issueCreatedByMeProvider.isError
                      ? const Center(child: Text("Error Occured"))
                      : issueCreatedByMeProvider.myIssuesList.isEmpty
                          ? const Text("No Issues Assigned To You")
                          : ListView.separated(
                              itemBuilder: (context, index) => Container(
                                padding: EdgeInsets.all(myPadding),
                                color: const Color.fromARGB(255, 244, 246, 247),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            issueCreatedByMeProvider
                                                .myIssuesList[index].title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge),
                                        hSizedBoxMedium(),
                                        PriorityBox(
                                          value: issueCreatedByMeProvider
                                              .myIssuesList[index].priority,
                                        ),
                                      ],
                                    ),
                                    vSizedBoxSmall(),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                      text:
                                                          issueCreatedByMeProvider
                                                              .myIssuesList[
                                                                  index]
                                                              .createdBy,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              vSizedBoxExSmall(),
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
                                                          issueCreatedByMeProvider
                                                              .myIssuesList[
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
                                            SizedBox(
                                              width:
                                                  widget.safesize.width * .12,
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: "Status : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                        text:
                                                            issueCreatedByMeProvider
                                                                .myIssuesList[
                                                                    index]
                                                                .status),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            vSizedBoxExSmall(),
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
                                                        issueCreatedByMeProvider
                                                            .myIssuesList[index]
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
                                                text: issueCreatedByMeProvider
                                                        .myIssuesList[index]
                                                        .assignedTo ??
                                                    "None",
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        CustomEditButton(
                                          issue: issueCreatedByMeProvider
                                              .myIssuesList[index],
                                        ),
                                        if (issueCreatedByMeProvider
                                                .myIssuesList[index]
                                                .assignedToId ==
                                            myId)
                                          CustomUpdateStatusButton(
                                            issue: issueCreatedByMeProvider
                                                .myIssuesList[index],
                                          ),
                                        CustomViewIssueButton(
                                          issue: issueCreatedByMeProvider
                                              .myIssuesList[index],
                                        ),
                                        if (issueCreatedByMeProvider
                                                .myIssuesList[index]
                                                .assignedToId !=
                                            myId)
                                          CustomAssignToMeButton(
                                              issue: issueCreatedByMeProvider
                                                  .myIssuesList[index]),
                                        CustomDeleteButton(
                                          issue: issueCreatedByMeProvider
                                              .myIssuesList[index],
                                        ),
                                        SizedBox(
                                            width: widget.safesize.width * .03)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemCount:
                                  issueCreatedByMeProvider.myIssuesList.length,
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
                        child: const Icon(Icons.sort),
                      ),
                      if (value) const SizedBox(height: 10),
                      if (value)
                        FloatingActionButton(
                          tooltip: "Sort By Date",
                          onPressed: () {
                            issueCreatedByMeProvider.sortIssuesByCreationDate();
                          },
                          child: const Icon(Icons.calendar_month),
                        ),
                      if (value) const SizedBox(height: 10),
                      if (value)
                        FloatingActionButton(
                          tooltip: "Sort By Priority",
                          onPressed: () {
                            issueCreatedByMeProvider.sortIssuesByPriority();
                          },
                          child: const Icon(Icons.low_priority),
                        ),
                      if (value) const SizedBox(height: 10),
                      if (value)
                        FloatingActionButton(
                          tooltip: "Sort By Updated",
                          onPressed: () {
                            issueCreatedByMeProvider.sortIssuesByUpdateDate();
                          },
                          child: const Icon(Icons.calendar_view_day_rounded),
                        ),
                      if (value) const SizedBox(height: 10),
                      if (value)
                        FloatingActionButton(
                          tooltip: "Sort By Status",
                          onPressed: () {
                            issueCreatedByMeProvider.sortIssuesByStatus();
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

// ListView.separated(
//                         itemBuilder: (context, index) => Container(
//                               padding: EdgeInsets.all(myPadding),
//                               color: const Color.fromARGB(255, 244, 246, 247),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Text(
//                                           sortedListProvider
//                                               .sortedList[index].title,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .titleLarge),
//                                       hSizedBoxMedium(),
//                                       PriorityBox(
//                                         value: sortedListProvider
//                                             .sortedList[index].priority,
//                                       ),
//                                     ],
//                                   ),
//                                   vSizedBoxSmall(),
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       SizedBox(
//                                         width: widget.safesize.width * .18,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text.rich(
//                                               TextSpan(
//                                                 children: [
//                                                   const TextSpan(
//                                                     text: "Created By: ",
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                   TextSpan(
//                                                     text: sortedListProvider
//                                                         .sortedList[index]
//                                                         .createdBy,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             Text.rich(
//                                               TextSpan(
//                                                 children: [
//                                                   const TextSpan(
//                                                     text: "Created : ",
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                   TextSpan(
//                                                     text: getIssueDayString(
//                                                         sortedListProvider
//                                                             .sortedList[index]
//                                                             .createdAt),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(
//                                             width: widget.safesize.width * .12,
//                                             child: Text.rich(
//                                               TextSpan(
//                                                 children: [
//                                                   const TextSpan(
//                                                     text: "Status : ",
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                   TextSpan(
//                                                       text: sortedListProvider
//                                                           .sortedList[index]
//                                                           .status),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           Text.rich(
//                                             TextSpan(
//                                               children: [
//                                                 const TextSpan(
//                                                   text: "Last Updated : ",
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                                 TextSpan(
//                                                   text: getIssueDayString(
//                                                       sortedListProvider
//                                                           .sortedList[index]
//                                                           .updatedAt),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Text.rich(
//                                         TextSpan(
//                                           children: [
//                                             const TextSpan(
//                                               text: "Assigned To : ",
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             TextSpan(
//                                               text: sortedListProvider
//                                                       .sortedList[index]
//                                                       .assignedTo ??
//                                                   "None",
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       const Spacer(),
//                                       CustomEditButton(
//                                         issue: sortedListProvider
//                                             .sortedList[index],
//                                       ),
//                                       if (sortedListProvider
//                                               .sortedList[index].assignedToId ==
//                                           myId)
//                                         CustomUpdateStatusButton(
//                                           issue: sortedListProvider
//                                               .sortedList[index],
//                                         ),
//                                       CustomViewIssueButton(
//                                         issue: sortedListProvider
//                                             .sortedList[index],
//                                       ),
//                                       CustomDeleteButton(
//                                         issue: sortedListProvider
//                                             .sortedList[index],
//                                       ),
//                                       SizedBox(
//                                           width: widget.safesize.width * .03)
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                         separatorBuilder: (context, index) =>
//                             const SizedBox(height: 10),
//                         itemCount: sortedListProvider.sortedList.length),















// ValueListenableBuilder(
//             valueListenable: isExpanded,
//             builder: (context, value, child) {
//               SortedListProvider provider =
//                   Provider.of<SortedListProvider>(context, listen: false);
//               return Align(
//                 alignment: Alignment.topRight,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     FloatingActionButton(
//                       tooltip: "sort",
//                       onPressed: () {
//                         isExpanded.value = !value;
//                       },
//                       child: Icon(Icons.sort),
//                     ),
//                     if (value) const SizedBox(height: 10),
//                     if (value)
//                       FloatingActionButton(
//                         tooltip: "Sort By Date",
//                         onPressed: () {
//                           provider.sortIssuesByCreationDate();
//                         },
//                         child: Icon(Icons.calendar_month),
//                       ),
//                     if (value) const SizedBox(height: 10),
//                     if (value)
//                       FloatingActionButton(
//                         tooltip: "Sort By Priority",
//                         onPressed: () {
//                           provider.sortIssuesByPriority();
//                         },
//                         child: Icon(Icons.low_priority),
//                       ),
//                     if (value) const SizedBox(height: 10),
//                     if (value)
//                       FloatingActionButton(
//                         tooltip: "Sort By Updated",
//                         onPressed: () {
//                           provider.sortIssuesByUpdateDate();
//                         },
//                         child: Icon(Icons.calendar_view_day_rounded),
//                       ),
//                     if (value) const SizedBox(height: 10),
//                     if (value)
//                       FloatingActionButton(
//                         tooltip: "Sort By Status",
//                         onPressed: () {
//                           provider.sortIssuesByStatus();
//                         },
//                         child: Icon(Icons.query_stats_outlined),
//                       ),
//                   ],
//                 ),
//               );
//             },
//           )
