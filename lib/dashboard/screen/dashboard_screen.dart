import 'package:brd_issue_tracker/dashboard/provider/all_issue_provider.dart';
import 'package:brd_issue_tracker/dashboard/provider/area_chart_provider.dart';
import 'package:brd_issue_tracker/dashboard/provider/my_issue_provider.dart';
import 'package:brd_issue_tracker/dashboard/widgets/all_issues/all_issues_home.dart';
import 'package:brd_issue_tracker/dashboard/widgets/my_issues/my_issues_home.dart';
import 'package:brd_issue_tracker/login/providers/auth_provider.dart';
import 'package:brd_issue_tracker/shared/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../navbar/my_navbar.dart';
import '../../navbar/navbar_data.dart';
import '../provider/donut_chart_provider.dart';
import '../widgets/home/dash_board_home.dart';
import '../widgets/issues_assigned_to_me/issues_assigned_to_me_screen.dart';
import '../widgets/statbox_row.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key, required this.authToken});
  static String approute = "/dashboard/home";
  final String authToken;
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<AreaChartProvider>(context, listen: false);
    Provider.of<DonutChartProvider>(context, listen: false)
        .getDonutData(widget.authToken);
    Provider.of<MyIssuesProvider>(context, listen: false)
        .getMyIssues(widget.authToken);
    Provider.of<AllIssuesProvider>(context, listen: false)
        .getAllIssues(widget.authToken);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double myPadding = 12;
    Size safeSize = Size(mediaQueryData.size.width - myPadding * 2,
        mediaQueryData.size.height - myPadding * 2);

    bool searchbool = _selectIndex != 0;
    UserModel loggedInUser =
        Provider.of<AuthProvider>(context, listen: false).loggedInUser!;
    List<Widget> route = [
      DashBoardHome(safeSize: safeSize, authToken: widget.authToken),
      AssignedIssueHome(authToken: widget.authToken, safesize: safeSize),
      MyIssueHome(authToken: widget.authToken, safesize: safeSize),
      AllIssuesHome(authToken: widget.authToken, safesize: safeSize)
    ];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(myPadding),
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              MyNavBar(
                safeSize: safeSize,
                selectedIndex: _selectIndex,
                navbarData: loggedInUser.isAdmin ? [] : userButtonData,
                onClicked: (id) => setState(
                  () {
                    _selectIndex = id;
                  },
                ),
              ),
              Container(
                width: safeSize.width * .83,
                height: safeSize.height,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatBoxRow(searchBool: searchbool),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: route[_selectIndex],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
