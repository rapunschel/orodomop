import 'package:flutter/material.dart';
import 'package:orodomop/models/timer_model.dart';
import 'package:provider/provider.dart';

class PauseOrResumeButton extends StatelessWidget {
  const PauseOrResumeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TimerModel, TimerState>(
      selector: (context, timerModel) => timerModel.timerState,
      builder: (context, timerState, child) {
        return SizedBox(
          width: 102, // Min width of button
          child: ElevatedButton(
            onPressed: () {
              TimerModel model = context.read<TimerModel>();

              timerState.isOnFocus || timerState.isOnBreak
                  ? model.pause()
                  : model.resume();
            },
            child: Text(
              timerState.isOnFocus || timerState.isOnBreak ? "Pause" : "Resume",
            ),
          ),
        );
      },
    );
  }
}
