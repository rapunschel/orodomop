import 'package:flutter/material.dart';
import 'package:orodomop/timer_model.dart';
import 'package:orodomop/widgets/buttons/break_button.dart';
import 'package:orodomop/widgets/buttons/end_break_button.dart';
import 'package:orodomop/widgets/buttons/pause_or_resume_button.dart';
import 'package:orodomop/widgets/buttons/start_button.dart';
import 'package:provider/provider.dart';

class TimerControlRow extends StatelessWidget {
  const TimerControlRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TimerModel, List<int>>(
      selector:
          (context, timerModel) => [
            timerModel.focusTime,
            timerModel.breakTimeRemaining,
          ],
      builder: (context, values, child) {
        int focusTime = values[0];
        int breakTime = values[1];
        if (focusTime == 0 && breakTime == 0) {
          return StartButton();
        }

        if (breakTime > 0) {
          return EndBreakButton();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [PauseOrResumeButton(), SizedBox(width: 16), BreakButton()],
        );
      },
    );
  }
}
