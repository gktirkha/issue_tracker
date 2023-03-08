import 'package:brd_issue_tracker/dashboard/api/create_user_api.dart';
import 'package:brd_issue_tracker/login/providers/auth_provider.dart';
import 'package:brd_issue_tracker/shared/util.dart';
import 'package:brd_issue_tracker/shared/util_widgets.dart';
import 'package:brd_issue_tracker/static_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<bool?> showNewUserDialog(BuildContext context) async {
  ValueNotifier<String> selectedDepartment = ValueNotifier(departmentList[0]);
  ValueNotifier<int> passwordlength = ValueNotifier(0);
  ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  MediaQueryData mediaQueryData = MediaQuery.of(context);
  String token =
      Provider.of<AuthProvider>(context, listen: false).loggedInUser!.token!;

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
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(label: Text("Name")),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(label: Text("email")),
                ),
                ValueListenableBuilder(
                  valueListenable: isPasswordVisible,
                  builder: (context, visibleBool, child) => TextField(
                    onChanged: (value) => passwordlength.value = value.length,
                    obscureText: !visibleBool,
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "Must Be 8 Char or more",
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
                                passwordlength.value = 9;
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
                ValueListenableBuilder(
                  valueListenable: passwordlength,
                  builder: (context, passLen, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: passLen < 8
                            ? null
                            : () async {
                                passwordlength.value = 0;
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
                              },
                        child: const Text("Create"),
                      )
                    ],
                  ),
                )
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
