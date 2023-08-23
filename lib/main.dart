// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes/adapter/task_adapter.dart';
import 'package:notes/menu/main_menu.dart';
import 'package:notes/provider/animated_container_provider.dart';
import 'package:provider/provider.dart';

import 'adapter/note_adapter.dart';
import 'provider/add_event_provider.dart';
import 'provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NotesAdapter());
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox('notes');
  await Hive.openBox('tasks');
  Animate.restartOnHotReload = true;
  //Notifications

  // AwesomeNotifications().initialize(
  //     // set the icon to null if you want to use the default app icon
  //     'resource://drawable/res_app_icon',
  //     [
  //       NotificationChannel(
  //           channelGroupKey: 'basic_channel_group',
  //           channelKey: 'basic_channel',
  //           channelName: 'Basic notifications',
  //           channelDescription: 'Notification channel for basic tests',
  //           defaultColor: const Color(0xFF9D50DD),
  //           ledColor: Colors.white)
  //     ],
  //     // Channel groups are only visual and are not required
  //     channelGroups: [
  //       NotificationChannelGroup(
  //           channelGroupKey: 'basic_channel_group',
  //           channelGroupName: 'Basic group')
  //     ],
  //     debug: true);
  //
  // ReceivedAction? receivedAction = await AwesomeNotifications()
  //     .getInitialNotificationAction(removeFromActionEvents: false);
  // if (receivedAction?.channelKey == 'call_channel')
  //   setInitialPageToCallPage();
  // else
  //   setInitialPageToHomePage();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(),
      ),
      ChangeNotifierProvider<AnimatedContainerProvider>(
        create: (_) => AnimatedContainerProvider(),
      ),
      ChangeNotifierProvider<AddEventProvider>(
        create: (_) => AddEventProvider(),
      ),
    ], child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static const String name = 'TaskNotes - Demo';

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // AwesomeNotifications().setListeners(
    //     onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    //     onNotificationCreatedMethod:
    //         NotificationController.onNotificationCreatedMethod,
    //     onNotificationDisplayedMethod:
    //         NotificationController.onNotificationDisplayedMethod,
    //     onDismissActionReceivedMethod:
    //         NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return MaterialApp(
        navigatorKey: MyApp.navigatorKey,
        title: MyApp.name,
        // initialRoute: '/',
        // onGenerateRoute: (settings) {
        //   switch (settings.name) {
        //     case '/':
        //       return MaterialPageRoute(
        //         builder: (context) => const MainMenu(title: MyApp.name),
        //       );
        //
        //     // case '/notification-page':
        //     //   return MaterialPageRoute(
        //     //     builder: (context) {
        //     //       final ReceivedAction receivedAction =
        //     //           settings.arguments as ReceivedAction;
        //     //       return MyNotificationPage(receivedAction: receivedAction);
        //     //     },
        //     //   );
        //
        //     default:
        //       assert(false, 'Page ${settings.name} not found');
        //       return null;
        //   }
        // },
        theme: ThemeData.light().copyWith(
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
            elevation: 0,
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
            elevation: 0,
          ),
          scaffoldBackgroundColor: const Color(0xFF1f1d2b),
        ),
        themeMode: provider.themeMode,
        home: const MainMenu(),
      );
    });
  }
}
