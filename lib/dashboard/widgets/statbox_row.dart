import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dialogs/new_user_dialog.dart';
import '../../shared/utils/util_widgets.dart';
import '../provider/donut_chart_provider.dart';
import '../../dialogs/create_issue_dialog.dart';
import '../../login/providers/auth_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../provider/issues_assigned_to_me_provider.dart';

class StatBoxRow extends StatelessWidget {
  const StatBoxRow(
      {super.key, this.searchBool = true, required this.voidCallback});
  final bool searchBool;
  final VoidCallback voidCallback;

  @override
  Widget build(BuildContext context) {
    bool isAdmin = Provider.of<AuthProvider>(context).loggedInUser!.isAdmin;
    return Container(
      color: Colors.blueGrey[100],
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<AuthProvider>(
            builder: (context, value, child) => Row(
              children: [
                Text("Hello ${value.loggedInUser!.name}"),
                const Spacer(),
                IconButton(
                    onPressed: voidCallback, icon: const Icon(Icons.refresh))
              ],
            ),
          ),
          vSizedBoxMedium(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "DashBoard",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Colors.black),
              ),
              const Spacer(),
              !searchBool
                  ? const SizedBox()
                  : Flexible(
                      child: TextField(
                        cursorColor: Colors.deepOrange,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
              hSizedBoxSmall(),
              if (isAdmin)
                ElevatedButton(
                  onPressed: () async {
                    await showNewUserDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.all(22),
                      backgroundColor: Colors.deepOrange),
                  child: const Text("Create a New User"),
                ),
              hSizedBoxSmall(),
              ElevatedButton(
                onPressed: () async {
                  await showCreateDialog(context);
                },
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.all(22),
                    backgroundColor: Colors.deepOrange),
                child: const Text("Create a New Issue"),
              )
            ],
          ),
          vSizedBoxMedium(),
          Consumer2<DonutChartProvider, IssuesAssignedToMeProvider>(
            builder: (context, value, value2, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: (value.isLoading || value2.isLoading)
                  ? [
                      const SpinKitFadingCube(
                          color: Colors.deepOrange, size: 50)
                    ]
                  : (value.isError || value2.isError)
                      ? [
                          const Text("Error Occured, Please Refresh"),
                        ]
                      : [
                          statBox(
                            title: "Total",
                            stat: value.count.toString(),
                            context: context,
                          ),
                          statBox(
                            title: "Assigned To Me",
                            stat:
                                value2.issuesAssignedToMeList.length.toString(),
                            context: context,
                          ),
                          statBox(
                            title: "Un-Assigned",
                            stat: value.donutChartMap["unAssignedCount"]!
                                .toString(),
                            context: context,
                          ),
                          statBox(
                            title: "Completed",
                            stat: value.donutChartMap["completedCount"]!
                                .toString(),
                            context: context,
                          )
                        ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget statBox(
    {required String title,
    required String stat,
    Widget? child,
    required BuildContext context}) {
  MediaQueryData mediaQueryData = MediaQuery.of(context);

  TextStyle statBoxTextStyle =
      Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Colors.black87,
            overflow: TextOverflow.clip,
          );
  return Container(
    width: mediaQueryData.size.width * .15,
    height: mediaQueryData.size.height * .14,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey[400]!),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(title,
              style: statBoxTextStyle.copyWith(
                  fontSize: mediaQueryData.textScaleFactor * 20)),
        ),
        vSizedBoxSmall(),
        FittedBox(
          fit: BoxFit.fitWidth,
          child: child == null
              ? Text(
                  stat,
                  style: statBoxTextStyle,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(stat, style: statBoxTextStyle),
                    SizedBox(
                      width: mediaQueryData.size.height * .14,
                    ),
                    child,
                  ],
                ),
        ),
      ],
    ),
  );
}
