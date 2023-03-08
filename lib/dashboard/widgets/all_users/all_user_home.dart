import 'package:brd_issue_tracker/dashboard/provider/all_issue_provider.dart';
import 'package:brd_issue_tracker/dashboard/provider/all_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

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
        builder: (context, allUserProvider, child) => allUserProvider.isLoading
            ? const SpinKitFadingCube(color: Colors.deepOrange)
            : allUserProvider.isError
                ? const Text("Error Occured")
                : Stack(
                    children: [
                      ListView.separated(
                          itemBuilder: (context, index) =>
                              Text(allUserProvider.userList[index].name),
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          itemCount: allUserProvider.userList.length)
                    ],
                  ),
      ),
    );
  }
}
