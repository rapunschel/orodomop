import 'package:flutter/material.dart';
import 'package:orodomop/providers/timer_provider.dart';
import 'package:orodomop/models/timer_state.dart';
import 'package:orodomop/screens/timer_screen/widgets/buttons/reset_button.dart';
import 'package:orodomop/screens/timer_screen/pomodoro/break_button.dart';
import 'package:orodomop/screens/timer_screen/widgets/buttons/end_break_button.dart';
import 'package:orodomop/screens/timer_screen/widgets/buttons/pause_or_resume_button.dart';
import 'package:orodomop/screens/timer_screen/widgets/buttons/start_button.dart';
import 'package:provider/provider.dart';

class TimerControlRow extends StatelessWidget {
  const TimerControlRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<
      TimerProvider,
      ({int focusTime, int breakTime, TimerState timerState})
    >(
      selector:
          (context, timerModel) => (
            focusTime: timerModel.focusTime,
            breakTime: timerModel.breakTimeRemaining,
            timerState: timerModel.timerState,
          ),
      builder: (context, values, child) {
        bool onBreak =
            (values.breakTime > 0 && values.timerState.isPaused) ||
            values.timerState.isOnBreak;

        bool onFocus =
            (values.focusTime > 0 && values.timerState.isPaused) ||
            values.timerState.isOnFocus;

        if (values.timerState.isIdle && values.focusTime > 0) {
          return StartButton();
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                onBreak || onFocus ? PauseOrResumeButton() : BreakButton(),
                SizedBox(width: 16),
                onFocus ? ResetButton() : EndBreakButton(),
              ],
            ),
          ],
        );
      },
    );
  }
}
