import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
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

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StopWatchWidget(),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PauseOrResumeButton(),
                SizedBox(width: 16),
                ElevatedButton(onPressed: () {}, child: Text("Break")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PauseOrResumeButton extends StatelessWidget {
  const PauseOrResumeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TimerModel, bool>(
      selector: (context, timerModel) => timerModel.isCounting,
      builder: (context, isCounting, child) {
        return ElevatedButton(
          onPressed: () {
            TimerModel model = context.read<TimerModel>();

            if (isCounting) {
              // Pause
              model.pause();
            } else {
              model.resume();
            }
          },
          child: Text(isCounting ? "Pause" : "Resume"),
        );
      },
    );
  }
}

class StopWatchWidget extends StatelessWidget {
  const StopWatchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TimerModel, int>(
      selector: (context, timerModel) => timerModel.focusTime,
      builder: (context, focusTime, child) {
        return Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 3),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
              child: AutoSizeText(
                TimerModel.formatTime(focusTime),
                maxLines: 1,
                maxFontSize: 68,
                style: TextStyle(fontSize: 68),
              ),
            ),
          ),
        );
      },
    );
  }
}
