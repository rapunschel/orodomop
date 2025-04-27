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
    return Consumer<TimerModel>(
      builder: (context, model, child) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                model.isOnBreak ? CountDownWatch() : CustomStopWatch(),
                SizedBox(height: 16),
                TimerControlRow(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TimerControlRow extends StatelessWidget {
  const TimerControlRow({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<TimerModel>();

    if (model.focusTime == 0 && model.breakTimeRemaining == 0) {
      return StartButton();
    }

    if (model.isOnBreak) {
      return EndBreakButton();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [PauseOrResumeButton(), SizedBox(width: 16), BreakButton()],
    );
  }
}

class BreakButton extends StatelessWidget {
  const BreakButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Trigger the dialog to show up
        _showBreakDialog(context);
      },
      child: Text("Break"),
    );
  }

  // Function to show the dialog
  void _showBreakDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BreakDialog();
      },
    );
  }
}

class EndBreakButton extends StatelessWidget {
  const EndBreakButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<TimerModel>().resetTimer();
      },
      child: Text("Stop"),
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<TimerModel>().start();
      },
      child: Text("Start"),
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

class CountDownWatch extends StatelessWidget {
  const CountDownWatch({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TimerModel, int>(
      selector: (context, timerModel) => timerModel.breakTimeRemaining,
      builder: (context, time, child) {
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
                TimerModel.formatTime(time),
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

class CustomStopWatch extends StatelessWidget {
  const CustomStopWatch({super.key});

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

class BreakDialog extends StatelessWidget {
  BreakDialog();

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: Text("Set Break Duration (1/X)"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter X'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final value = controller.text;
            if (value.isNotEmpty) {
              int x = int.tryParse(value) ?? 1; // Default to 1 if invalid
              context.read<TimerModel>().relax(x);
            }
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Just close the dialog
          },
          child: Text("Cancel"),
        ),
      ],
    );
  }
}
