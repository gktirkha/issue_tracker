import 'package:flutter/material.dart';

import 'area_chart.dart';
import 'donut_chart.dart';
import 'issues_assigned_to_me.dart';
import 'my_issues.dart';

class DashBoardHome extends StatelessWidget {
  const DashBoardHome(
      {super.key, required this.safeSize, required this.authToken});
  final Size safeSize;
  final String authToken;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          width: (safeSize.width * .80) * .40,
          height: safeSize.height * 1.3,
          child: SingleChildScrollView(
            child: MyIssues(authToken: authToken),
          ),
        ),
        SizedBox(
          width: safeSize.width * .01,
        ),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              width: (safeSize.width * .80) * .60,
              height: safeSize.height * .5,
              child: Row(
                children: [
                  SizedBox(
                    width: ((safeSize.width * .80) * .59) / 2,
                    child: AreaChart(authToken: authToken),
                  ),
                  SizedBox(
                    width: ((safeSize.width * .80) * .59) / 2,
                    child: DonutChart(authToken: authToken),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: safeSize.height * .02,
            ),
            Container(
              width: (safeSize.width * .80) * .60,
              height: safeSize.height * .78,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: SingleChildScrollView(
                child: IssuesAssignedToMe(authToken: authToken),
              ),
            )
          ],
        )
      ],
    );
  }
}
