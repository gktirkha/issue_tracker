import 'package:brd_issue_tracker/dashboard/api/create_user_api.dart';
import 'package:brd_issue_tracker/login/providers/auth_provider.dart';
import 'package:brd_issue_tracker/shared/utils/util_methods.dart';
import 'package:brd_issue_tracker/shared/utils/util_widgets.dart';
import 'package:brd_issue_tracker/shared/utils/static_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<bool?> showNewUserDialog(BuildContext context) async {
  ValueNotifier<String> selectedDepartment = ValueNotifier(departmentList[0]);
  ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  MediaQueryData mediaQueryData = MediaQuery.of(context);
  String token =
      Provider.of<AuthProvider>(context, listen: false).loggedInUser!.token!;
  final formKey = GlobalKey<FormState>();

  Future<void> createUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    await createUserService(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
            department: selectedDepartment.value,
            token: token)
        .then((value) {
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
                    "Create User",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                    validator: (value) {
                      if (value == null) {
                        return "please input Name";
                      }
                      if (value.isEmpty || value.length < 4) {
                        return "Minimum Length Should Be 4";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value == null) {
                        return "please input Email";
                      }
                      if (value.isEmpty || value.length < 8) {
                        return "Minimum Length Should Be 8";
                      }
                      return null;
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: isPasswordVisible,
                    builder: (context, visibleBool, child) => TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return "please input title";
                        }
                        if (value.isEmpty || value.length < 8) {
                          return "Minimum Length Should Be 8";
                        }
                        return null;
                      },
                      obscureText: !visibleBool,
                      controller: passwordController,
                      decoration: InputDecoration(
                        label: const Text("password"),
                        suffix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Tooltip(
                              message: "Genrate Random",
                              child: InkWell(
                                splashColor: Colors.deepOrange,
                                onTap: () {
                                  passwordController.text =
                                      generateRandomString(9);
                                },
                                child: const Icon(Icons.password),
                              ),
                            ),
                            hSizedBoxMedium(),
                            Tooltip(
                              message: "Password Visibility",
                              child: InkWell(
                                splashColor: Colors.deepOrange,
                                onTap: () {
                                  isPasswordVisible.value = !visibleBool;
                                },
                                child: Icon(!visibleBool
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
