import 'package:flutter/material.dart';
import 'package:orodomop/timer_model.dart';
import 'package:orodomop/widgets/buttons/timer_control_row.dart';
import 'package:orodomop/widgets/stopwatches/count_down_watch.dart';
import 'package:orodomop/widgets/stopwatches/custom_stop_watch.dart';
import 'package:provider/provider.dart';

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
