import 'package:brd_issue_tracker/dashboard/provider/all_user_provider.dart';
import 'package:brd_issue_tracker/login/providers/auth_provider.dart';
import 'package:brd_issue_tracker/shared/util_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AllUsersHome extends StatefulWidget {
  const AllUsersHome(
      {super.key, required this.authToken, required this.safesize});
  final String authToken;
  final Size safesize;

  @override
  State<AllUsersHome> createState() => _AllUsersHomeState();
}

class _AllUsersHomeState extends State<AllUsersHome> {
  double myPadding = 16;
  @override
  Widget build(BuildContext context) {
    final String myId = Provider.of<AuthProvider>(context).loggedInUser!.id;
    return Container(
      height: widget.safesize.height * .90,
      width: widget.safesize.width * .90,
      padding: EdgeInsets.all(myPadding),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Consumer<AllUserProvider>(
        builder: (context, allUserProvider, child) => Container(
          child: allUserProvider.isLoading
              ? const SpinKitFadingCube(color: Colors.deepOrange)
              : allUserProvider.isError
                  ? const Text("Error Occured")
                  : ListView.separated(
                      itemBuilder: (context, index) => Container(
                        color: const Color.fromARGB(255, 244, 246, 247),
                        padding: EdgeInsets.all(myPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: widget.safesize.width * .12,
                                  child: Text(
                                    allUserProvider.userList[index].name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                const Spacer(),
                                if (allUserProvider.userList[index].id == myId)
                                  const YouBox(),
                                hSizedBoxMedium(),
                                if (allUserProvider.userList[index].isAdmin)
                                  AdminBox(
                                    isAdmin:
                                        allUserProvider.userList[index].isAdmin,
                                  ),
                                SizedBox(width: widget.safesize.width * .03)
                              ],
                            ),
                            vSizedBoxSmall(),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: widget.safesize.width * .2,
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "Department : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: allUserProvider
                                                  .userList[index].department,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    vSizedBoxSmall(),
                                    SizedBox(
                                      width: widget.safesize.width * .2,
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "Created At : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: DateFormat("dd/MM/yyyy")
                                                  .format(
                                                DateTime.parse(
                                                  allUserProvider
                                                      .userList[index]
                                                      .createdAt!,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: widget.safesize.width * .01),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: widget.safesize.width * .3,
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "Email : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: allUserProvider
                                                  .userList[index].email,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    vSizedBoxSmall(),
                                    SizedBox(
                                      width: widget.safesize.width * .3,
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "Assigned Cases : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: allUserProvider
                                                  .userList[index].assignCount!
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                if (allUserProvider.userList[index].id != myId)
                                  CustomEditUserButton(
                                    user: allUserProvider.userList[index],
                                  ),
                                if (!allUserProvider.userList[index].isAdmin)
                                  CustomDeleteUserButton(
                                    user: allUserProvider.userList[index],
                                  ),
                                SizedBox(width: widget.safesize.width * .03)
                              ],
                            ),
                          ],
                        ),
                      ),
                      separatorBuilder: (context, index) => vSizedBoxMedium(),
                      itemCount: allUserProvider.userList.length,
                    ),
        ),
      ),
    );
  }
}
