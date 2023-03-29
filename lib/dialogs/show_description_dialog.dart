import 'package:flutter/material.dart';
import '../shared/utils/util_widgets.dart';
import '../shared/models/issues_model.dart';

Future<bool?> showDescriptionDialog(BuildContext context, Issue issue) async {
  return showGeneralDialog<bool>(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      Size size = MediaQuery.of(context).size;
      return Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: size.width / 2,
          height: size.height / 2,
          margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    Row(
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
                        PriorityBox(value: issue.priority)
                      ],
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
                    StatusBox(
                      status: issue.status,
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
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      side: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: const Text("Dismiss"),
                  ),
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
        tween = Tween(begin: const Offset(0, .1), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(0, -.1), end: Offset.zero);
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
