import 'package:flutter/material.dart';
import '../shared/models/user_model.dart';
import '../shared/utils/util_widgets.dart';
import '../dashboard/api/delete_user_api.dart';

Future<bool?> showDeleteUserDialog(
    BuildContext context, UserModel userModel, String token) async {
  ValueNotifier<bool> isEnable = ValueNotifier(true);
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
                const Text("Are You Sure You Want to Delete This User?"),
                vSizedBoxLarge(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: isEnable,
                      builder: (context, value, child) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange),
                        onPressed: !value
                            ? null
                            : () async {
                                isEnable.value = !value;
                                await deleteUserService(
                                        id: userModel.id, token: token)
                                    .then(
                                  (value) {
                                    if (value == true) {
                                      refresh(context);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("User Deleted Sucesfully"),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                        child: const Text("yes"),
                      ),
                    ),
                    hSizedBoxMedium(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text("no"),
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
