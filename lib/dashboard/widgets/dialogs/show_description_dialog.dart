import 'package:brd_issue_tracker/shared/models/issues_model.dart';
import 'package:brd_issue_tracker/shared/util_widgets.dart';
import 'package:brd_issue_tracker/static_data.dart';
import 'package:flutter/material.dart';

Future<bool?> showDescriptionDialog(BuildContext context, Issue issue) async {
  return showGeneralDialog<bool>(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      Size size = MediaQuery.of(context).size;
      return Center(
        child: Container(
          padding: EdgeInsets.all(16),
          width: size.width / 2,
          height: size.height / 2,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Material(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${issue.title}: ",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: size.width / 2 * .03,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                                color: priorityColor(issue.priority),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              issue.priority,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Assigned To: ",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      issue.assignedTo ?? "None",
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  ],
                ),
                vSizedBoxSmall(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Status: ",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    hSizedBoxMedium(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                          color: statusColor(issue.status),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        issue.status.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                vSizedBoxMedium(),
                Text(
                  "Description: ",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                vSizedBoxSmall(),
                Text(
                  issue.description,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      child: Text("Dismiss"),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: Offset(0, .1), end: Offset.zero);
      } else {
        tween = Tween(begin: Offset(0, -.1), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}
