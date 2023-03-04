import 'package:brd_issue_tracker/dashboard/provider/all_issue_provider.dart';
import 'package:brd_issue_tracker/dashboard/provider/area_chart_provider.dart';
import 'package:brd_issue_tracker/dashboard/provider/donut_chart_provider.dart';
import 'package:brd_issue_tracker/dashboard/provider/issues_assigned_to_me_provider.dart';
import 'package:brd_issue_tracker/dashboard/provider/my_issue_provider.dart';
import 'package:brd_issue_tracker/dashboard/provider/sorted_list_provider.dart';
import 'package:brd_issue_tracker/dashboard/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'login/providers/auth_provider.dart';
import 'login/screen/login_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<AreaChartProvider>(
          create: (context) => AreaChartProvider(),
        ),
        ChangeNotifierProvider<DonutChartProvider>(
          create: (context) => DonutChartProvider(),
        ),
        ChangeNotifierProvider<IssuesAssignedToMeProvider>(
          create: (context) => IssuesAssignedToMeProvider(),
        ),
        ChangeNotifierProvider<MyIssuesProvider>(
          create: (context) => MyIssuesProvider(),
        ),
        ChangeNotifierProvider<SortedListProvider>(
          create: (context) => SortedListProvider(),
        ),
        ChangeNotifierProvider<AllIssuesProvider>(
          create: (context) => AllIssuesProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepOrange).copyWith(
            scaffoldBackgroundColor: const Color.fromARGB(255, 73, 79, 95)),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Consumer<AuthProvider>(
          builder: (context, value, child) {
            return value.isLoading
                ? const SpinKitCubeGrid(color: Colors.deepOrange)
                : value.error
                    ? const LoginScreen()
                    : value.isLoggedIn
                        ? DashBoardScreen(authToken: value.loggedInUser!.token)
                        : const LoginScreen();
          },
        );
      },
    );
  }
}
