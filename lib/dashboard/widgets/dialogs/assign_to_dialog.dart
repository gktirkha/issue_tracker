import 'dart:developer';

import 'package:brd_issue_tracker/dashboard/provider/all_user_provider.dart';
import 'package:brd_issue_tracker/shared/util_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/models/user_model.dart';

Future<String?> showAssignDialog(BuildContext context) async {
  return showGeneralDialog<String>(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      Size size = MediaQuery.of(context).size;
      Map<String, List<UserModel>> allUserMap =
          Provider.of<AllUserProvider>(context).userMap;

      List<String> departments = allUserMap.keys.toList();
      ValueNotifier<int> selIndex = ValueNotifier(0);
      ValueNotifier<int> selUserIndex = ValueNotifier(0);

      return Center(
        child: Container(
          width: size.width / 2,
          height: size.height * .55,
          padding: EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Material(
              color: Colors.white,
              child: ValueListenableBuilder(
                valueListenable: selIndex,
                builder: (context, value, child) {
                  List<UserModel> list = allUserMap[departments[value]]!;
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: size.width / 2 * .48,
                            height: size.height / 2,
                            padding: const EdgeInsets.all(16),
                            child: ListView.separated(
                                itemBuilder: (context, index) => ListTile(
                                      title: Text(departments[index]),
                                      tileColor: index == value
                                          ? Colors.deepOrange
                                          : null,
                                      onTap: () {
                                        selUserIndex.value = 0;
                                        selIndex.value = index;
                                      },
                                      textColor: index == value
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                itemCount: departments.length),
                          ),
                          VerticalDivider(width: size.width / 2 * .02),
                          Container(
                            width: size.width / 2 * .48,
                            height: size.height / 2,
                            padding: const EdgeInsets.all(16),
                            child: ValueListenableBuilder(
                              valueListenable: selUserIndex,
                              builder: (context, selUserIn, child) =>
                                  ListView.separated(
                                      itemBuilder: (context, index) {
                                        bool isSelected = index == selUserIn;
                                        return ListTile(
                                          subtitle: Text(
                                              "Currently Assigned To ${list[index].assignCount} cases"),
                                          title: Text(list[index].name),
                                          tileColor: isSelected
                                              ? Colors.deepOrange
                                              : null,
                                          textColor: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          onTap: () {
                                            selUserIndex.value = index;
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 10),
                                      itemCount: list.length),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              log(list[selUserIndex.value].name);
                            },
                            child: const Text("Discard"),
                          ),
                          hSizedBoxMedium(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                  context, list[selUserIndex.value].name);
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      )
                    ],
                  );
                },
              )),
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
