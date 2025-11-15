import 'package:flutter/material.dart';
import 'package:orodomop/models/timer_model.dart';
import 'package:orodomop/models/timer_state.dart';
import 'package:orodomop/widgets/control_row/buttons/break_button.dart';
import 'package:orodomop/widgets/control_row/buttons/end_break_button.dart';
import 'package:orodomop/widgets/control_row/buttons/pause_or_resume_button.dart';
import 'package:orodomop/widgets/control_row/buttons/reset_button.dart';
import 'package:orodomop/widgets/control_row/buttons/start_button.dart';
import 'package:provider/provider.dart';

class TimerControlRow extends StatelessWidget {
  const TimerControlRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<
      TimerModel,
      ({int focusTime, int breakTime, TimerState timerState})
    >(
      selector:
          (context, timerModel) => (
            focusTime: timerModel.focusTime,
            breakTime: timerModel.breakTimeRemaining,
            timerState: timerModel.timerState,
          ),
      builder: (context, values, child) {
        if (values.timerState.isIdle ||
            values.timerState.isOnBreak && values.breakTime == 0) {
          return StartButton();
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PauseOrResumeButton(),
                SizedBox(width: 16),
                (values.breakTime > 0 && values.timerState.isPaused) ||
                        values.timerState.isOnBreak
                    ? EndBreakButton()
                    : BreakButton(),
              ],
            ),
            values.timerState.isOnFocus || values.focusTime > 0
                ? ResetButton()
                : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
