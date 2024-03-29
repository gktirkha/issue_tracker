import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dialogs/error_dialog.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.showerror});
  final bool showerror;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);
  ValueNotifier<bool> isLogging = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double horzontalPadding = 130;
    double verticalPadding = 90;
    Size safeSize = Size(mediaQueryData.size.width - horzontalPadding * 2,
        mediaQueryData.size.height - verticalPadding * 2);

    Future<void> login(AuthProvider authProvider) async {
      isLogging.value = true;
      if (!formKey.currentState!.validate()) {
        isLogging.value = false;
        return;
      }
      await authProvider.login(
        email: emailController.text.trim().toString(),
        password: passwordController.text.trim().toString(),
      );
    }

    if (widget.showerror) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showErrorDialog(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Issue Tracker"),
        centerTitle: true,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.black, fontSize: 40),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horzontalPadding, vertical: verticalPadding),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  spreadRadius: 12,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/login.jpg",
                    width: safeSize.width * .45,
                    height: safeSize.height,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    color: Colors.white,
                    width: safeSize.width * .1,
                    child: const VerticalDivider(
                      color: Colors.grey,
                      thickness: 0,
                      indent: 40,
                      endIndent: 40,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: safeSize.width * .45,
                    padding: const EdgeInsets.all(32),
                    child: ValueListenableBuilder(
                      valueListenable: isLogging,
                      builder: (context, loggingBool, child) => Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: safeSize.width * .5,
                                height: 0,
                              ),
                              Text(
                                "Login",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(color: Colors.black),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                  "Don't Have An Account? Contact Administrator"),
                            ],
                          ),
                          const Spacer(),
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) => Form(
                              key: formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                      validator: (value) {
                                        if (value == null) {
                                          return "Please Enter Email";
                                        }
                                        if (value.length < 8) {
                                          return "Minimum length should be 8";
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.emailAddress,
                                      enabled: !loggingBool,
                                      controller: emailController,
                                      decoration: loginInputDecoration(context,
                                          hint: "Enter Your Email",
                                          label: "Email",
                                          iconData: Icons.email)),
                                  const SizedBox(height: 20),
                                  ValueListenableBuilder(
                                    valueListenable: isPasswordVisible,
                                    builder: (context, passwordBool, child) =>
                                        TextFormField(
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (value) {
                                        login(authProvider);
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return "Please Enter Password";
                                        }
                                        if (value.length < 8) {
                                          return "Please Enter Password";
                                        }
                                        return null;
                                      },
                                      enabled: !loggingBool,
                                      obscureText: !passwordBool,
                                      controller: passwordController,
                                      decoration: loginInputDecoration(context,
                                              hint: "Enter Your Password",
                                              label: "Password",
                                              iconData: Icons.key)
                                          .copyWith(
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            isPasswordVisible.value =
                                                !passwordBool;
                                          },
                                          child: Icon(
                                            passwordBool
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: safeSize.height * .15),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: Size(
                                          mediaQueryData.size.width * .30,
                                          mediaQueryData.size.height * .07),
                                      side: BorderSide(
                                          color: loggingBool
                                              ? Colors.grey
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                    ),
                                    onPressed: loggingBool
                                        ? null
                                        : () async {
                                            login(authProvider);
                                          },
                                    child: Text(!loggingBool
                                        ? "Login"
                                        : "Logging in ..."),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration loginInputDecoration(BuildContext context,
    {required String hint, required String label, required IconData iconData}) {
  return InputDecoration(
    labelText: label,
  );
}
