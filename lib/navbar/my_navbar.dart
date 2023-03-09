import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login/providers/auth_provider.dart';
import 'navbar_data.dart';

typedef IntCallback = void Function(int id);

// ignore: must_be_immutable
class MyNavBar extends StatelessWidget {
  MyNavBar({
    super.key,
    required this.safeSize,
    required this.onClicked,
    required this.navbarData,
    required this.selectedIndex,
  });
  final IntCallback onClicked;
  int selectedIndex;
  Size safeSize;
  List<NavBarData> navbarData;
  ValueNotifier<bool> isExpanded = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: safeSize.width * .17,
      color: const Color.fromARGB(255, 37, 39, 39),
      child: Column(
        children: [
          SizedBox(height: safeSize.height * .08),
          const Text("Issue Tracker", style: TextStyle(color: Colors.white)),
          SizedBox(height: safeSize.height * .08),
          ListView.builder(
            shrinkWrap: true,
            itemCount: navbarData.length,
            itemBuilder: (context, index) {
              Color color = index == selectedIndex
                  ? const Color.fromARGB(255, 73, 79, 95)
                  : const Color.fromARGB(255, 37, 39, 39);

              return ElevatedButton(
                onPressed: () {
                  onClicked(index);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  fixedSize: Size(
                    safeSize.width * .2,
                    safeSize.height * .06,
                  ),
                  backgroundColor: color,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    navbarData[index].icon,
                    SizedBox(
                      width: safeSize.width * .02,
                    ),
                    Flexible(child: Text(navbarData[index].title)),
                  ],
                ),
              );
            },
          ),
          const Spacer(),
          Material(
            color: const Color.fromARGB(255, 37, 39, 39),
            child: ValueListenableBuilder(
              valueListenable: isExpanded,
              builder: (context, value, child) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: safeSize.width * .2,
                child: Consumer<AuthProvider>(
                  builder: (context, auth, child) => Column(
                    children: [
                      ListTile(
                        onTap: () {
                          isExpanded.value = !value;
                        },
                        splashColor: Colors.grey,
                        leading: const CircleAvatar(
                          foregroundImage:
                              AssetImage("assets/images/avtar.jpg"),
                        ),
                        title: Text(
                          auth.loggedInUser!.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      if (value)
                        ElevatedButton(
                          onPressed: () {
                            auth.logout();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            fixedSize: Size(
                              safeSize.width * .2,
                              safeSize.height * .06,
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 37, 39, 39),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.zero),
                            ),
                          ),
                          child: SizedBox(
                            width: safeSize.width * .2,
                            child: const Text("Logout",
                                textAlign: TextAlign.start),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: safeSize.height * .03,
          )
        ],
      ),
    );
  }
}
