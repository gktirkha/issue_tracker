import 'package:brd_issue_tracker/dashboard/provider/my_issue_provider.dart';
import 'package:brd_issue_tracker/dashboard/provider/sorted_list_provider.dart';
import 'package:brd_issue_tracker/login/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../../../shared/util.dart';
import '../../../shared/util_widgets.dart';
import '../../../static_data.dart';

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
  @override
  void initState() {
    super.initState();

    if (!Provider.of<MyIssuesProvider>(context, listen: false).isLoading) {
      Provider.of<SortedListProvider>(context, listen: false).setSortedList(
          Provider.of<MyIssuesProvider>(context, listen: false).myIssuesList);
    }
  }

  ValueNotifier<bool> isExpanded = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    MyIssuesProvider myIssueProvider = Provider.of<MyIssuesProvider>(context);
    SortedListProvider sortedListProvider =
        Provider.of<SortedListProvider>(context);
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
      child: Stack(
        children: [
          Container(
            child: myIssueProvider.isLoading
                ? const Center(
                    child: SpinKitFadingCube(color: Colors.deepOrange))
                : myIssueProvider.isError
                    ? const Center(child: Text("Error Occured"))
                    : ListView.separated(
                        itemBuilder: (context, index) => Container(
                              padding: EdgeInsets.all(myPadding),
                              color: const Color.fromARGB(255, 244, 246, 247),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      sortedListProvider
                                          .sortedList[index].title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                  vSizedBoxSmall(),
                                  Row(
                                    children: [
                                      Container(
                                        color: priorityColor(
                                          sortedListProvider
                                              .sortedList[index].priority,
                                        ),
                                        height: widget.safesize.height * .05,
                                        width: widget.safesize.width * .05,
                                        child: Center(
                                          child: Text(
                                            sortedListProvider
                                                .sortedList[index].priority,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      hSizedBoxSmall(),
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
                                                    text: sortedListProvider
                                                        .sortedList[index]
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
                                                        sortedListProvider
                                                            .sortedList[index]
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
                                            width: widget.safesize.width * .12,
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
                                                      text: sortedListProvider
                                                          .sortedList[index]
                                                          .status),
                                                ],
                                              ),
                                            ),
                                          ),
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
                                                      sortedListProvider
                                                          .sortedList[index]
                                                          .updatedAt),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (sortedListProvider
                                                  .sortedList[index].status ==
                                              ASSIGNED)
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: "Assigned To: ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: sortedListProvider
                                                          .sortedList[index]
                                                          .assignedTo),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      const Spacer(),
                                      if (sortedListProvider
                                              .sortedList[index].asignedToId !=
                                          myId)
                                        TextButton(
                                            onPressed: () {},
                                            child: Text("Assign To Me")),
                                      TextButton(
                                          onPressed: () {},
                                          child: Text("Assign To other")),
                                      SizedBox(
                                          width: widget.safesize.width * .03)
                                    ],
                                  )
                                ],
                              ),
                            ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: sortedListProvider.sortedList.length),
          ),
          ValueListenableBuilder(
            valueListenable: isExpanded,
            builder: (context, value, child) {
              SortedListProvider provider =
                  Provider.of<SortedListProvider>(context, listen: false);
              return Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (value)
                      FloatingActionButton(
                        tooltip: "Sort By Date",
                        onPressed: () {
                          provider.sortIssuesByCreationDate();
                        },
                        child: Icon(Icons.calendar_month),
                      ),
                    if (value) const SizedBox(height: 10),
                    if (value)
                      FloatingActionButton(
                        tooltip: "Sort By Priority",
                        onPressed: () {
                          provider.sortIssuesByPriority();
                        },
                        child: Icon(Icons.low_priority),
                      ),
                    if (value) const SizedBox(height: 10),
                    if (value)
                      FloatingActionButton(
                        tooltip: "Sort By Updated",
                        onPressed: () {
                          provider.sortIssuesByUpdateDate();
                        },
                        child: Icon(Icons.calendar_view_day_rounded),
                      ),
                    if (value) const SizedBox(height: 10),
                    if (value)
                      FloatingActionButton(
                        tooltip: "Sort By Status",
                        onPressed: () {
                          provider.sortIssuesByStatus();
                        },
                        child: Icon(Icons.query_stats_outlined),
                      ),
                    if (value) const SizedBox(height: 10),
                    FloatingActionButton(
                      onPressed: () {
                        isExpanded.value = !value;
                      },
                      child: Icon(Icons.sort),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
