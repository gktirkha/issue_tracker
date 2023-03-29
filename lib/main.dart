import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login/screen/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'login/providers/auth_provider.dart';
import 'dashboard/screen/dashboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dashboard/provider/all_user_provider.dart';
import 'dashboard/provider/all_issue_provider.dart';
import 'dashboard/provider/area_chart_provider.dart';
import 'dashboard/provider/donut_chart_provider.dart';
import 'dashboard/provider/sorted_list_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dashboard/provider/issues_created_by_me_provider.dart';
import 'dashboard/provider/issues_assigned_to_me_provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
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
        ChangeNotifierProvider<IssuesCreatedByMeProvider>(
          create: (context) => IssuesCreatedByMeProvider(),
        ),
        ChangeNotifierProvider<SortedListProvider>(
          create: (context) => SortedListProvider(),
        ),
        ChangeNotifierProvider<AllIssuesProvider>(
          create: (context) => AllIssuesProvider(),
        ),
        ChangeNotifierProvider<AllUserProvider>(
          create: (context) => AllUserProvider(),
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AuthProvider>(context, listen: false).checkLogin();
    });
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
                    ? const LoginScreen(
                        showerror: true,
                      )
                    : value.isLoggedIn
                        ? DashBoardScreen(authToken: value.loggedInUser!.token!)
                        : const LoginScreen(
                            showerror: false,
                          );
          },
        );
      },
    );
  }
}
