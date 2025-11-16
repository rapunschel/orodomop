import 'package:flutter/material.dart';
import 'package:orodomop/providers/timer_provider.dart';
import 'package:orodomop/models/timer_state.dart';
import 'package:provider/provider.dart';

class PauseOrResumeButton extends StatelessWidget {
  const PauseOrResumeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TimerProvider, TimerState>(
      selector: (context, timerModel) => timerModel.timerState,
      builder: (context, timerState, child) {
        return ConstrainedBox(
          constraints: BoxConstraints(minWidth: 100),
          child: ElevatedButton(
            onPressed: () {
              TimerProvider model = context.read<TimerProvider>();

              timerState.isOnFocus || timerState.isOnBreak
                  ? model.pause()
                  : model.resume();
            },
            child: Text(
              timerState.isOnFocus || timerState.isOnBreak ? "Pause" : "Resume",
              softWrap: false,
            ),
          ),
        );
      },
    );
  }
}
