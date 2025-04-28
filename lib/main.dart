import 'package:flutter/material.dart';
import 'package:orodomop/screens/timer_screen.dart';
import 'package:provider/provider.dart';
import 'package:orodomop/timer_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final timerModel = await TimerModel.create();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => timerModel)],
      child: OrodomopApp(),
    ),
  );
}

class OrodomopApp extends StatelessWidget {
  const OrodomopApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugPrint("Restart");
    return MaterialApp(
      title: 'Orodomop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: TimerScreen(),
    );
  }
}
