import 'package:brd_issue_tracker/dashboard/api/update_user_api.dart';
import 'package:brd_issue_tracker/login/providers/auth_provider.dart';
import 'package:brd_issue_tracker/shared/models/user_model.dart';

import 'package:brd_issue_tracker/shared/util_widgets.dart';
import 'package:brd_issue_tracker/static_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<bool?> showEditUserDialog(
    BuildContext context, UserModel userModel) async {
  ValueNotifier<String> selectedDepartment =
      ValueNotifier(userModel.department);

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  MediaQueryData mediaQueryData = MediaQuery.of(context);
  String token =
      Provider.of<AuthProvider>(context, listen: false).loggedInUser!.token!;
  final formKey = GlobalKey<FormState>();

  nameController.text = userModel.name;
  emailController.text = userModel.email;

  Future<void> createUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    await updateUserService(
      name: nameController.text,
      email: emailController.text,
      department: selectedDepartment.value,
      id: userModel.id,
      token: token,
    ).then((value) {
      refresh(context);
      Navigator.pop(context);
    });
  }

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
          width: mediaQueryData.size.width / 2,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Form(
            key: formKey,
            child: Material(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Edit User",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Title"),
                    validator: (value) {
                      if (value == null) {
                        return "please input title";
                      }
                      if (value.isEmpty || value.length < 5) {
                        return "Minimum Length Should Be 5";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value == null) {
                        return "please input title";
                      }
                      if (value.isEmpty || value.length < 8) {
                        return "Minimum Length Should Be 8";
                      }
                      return null;
                    },
                  ),
                  vSizedBoxMedium(),
                  ValueListenableBuilder(
                    valueListenable: selectedDepartment,
                    builder: (context, depValue, child) => DropdownButton(
                      value: depValue,
                      items: departmentList
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedDepartment.value = value;
                        }
                      },
                    ),
                  ),
                  vSizedBoxLarge(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await createUser();
                        },
                        child: const Text("Create"),
                      )
                    ],
                  )
                ],
              ),
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
