import 'package:flutter/material.dart';
import 'package:orodomop/screens/timer_screen.dart';
import 'package:orodomop/themes/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:orodomop/models/timer_model.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:orodomop/services/notification_service.dart';
import 'package:orodomop/services/service_manager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(await FlutterTimezone.getLocalTimezone()));

  final timerModel = await TimerModel.create();
  await NotificationService().initNotification();

  FlutterForegroundTask.initCommunicationPort();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => timerModel)],
      child: OrodomopApp(),
    ),
  );
}

class OrodomopApp extends StatefulWidget {
  const OrodomopApp({super.key});

  @override
  State<OrodomopApp> createState() => _OrodomopAppState();
}

class _OrodomopAppState extends State<OrodomopApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      await context.read<TimerModel>().saveState();
    } else if (state == AppLifecycleState.detached) {
      ServiceManager.stopService();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Restart");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {'/': (context) => const TimerScreen()},
      initialRoute: '/',
      title: 'Orodomop',
      theme: lightTheme(),
    );
  }
}
