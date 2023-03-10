import 'package:flutter/material.dart';

Future<bool?> showErrorDialog(BuildContext context) async {
  return showGeneralDialog<bool>(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 200,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Material(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("An Error Occured, Please Re-check credentials and retry"),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Okay"))
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
