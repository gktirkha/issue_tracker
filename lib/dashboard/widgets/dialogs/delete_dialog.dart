import 'package:flutter/material.dart';
import '../../../shared/util_widgets.dart';

Future<bool?> showDeleteDialog(BuildContext context) async {
  return showGeneralDialog<bool>(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(16),
          width: 200,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Are You Sure You Want to Delete This Task?"),
                vSizedBoxLarge(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text("yes"),
                    ),
                    hSizedBoxMedium(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text("no"),
                    ),
                  ],
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
