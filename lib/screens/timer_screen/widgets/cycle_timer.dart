import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:orodomop/providers/timer_provider.dart';
import 'package:orodomop/models/timer_state.dart';
import 'package:provider/provider.dart';
import 'package:orodomop/utils/string_formatter.dart';
import 'package:glowy_borders/glowy_borders.dart';

class CycleTimer extends StatelessWidget {
  const CycleTimer({super.key});

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
        bool isActive =
            values.timerState.isOnBreak || values.timerState.isOnFocus;
        return AnimatedGradientBorder(
          animationProgress: (isActive) ? null : 0,
          borderSize: 4,
          glowSize: 10,
          gradientColors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.inversePrimary,
          ],
          borderRadius: BorderRadius.all(Radius.circular(999)),
          child: SizedBox(
            width: 250,
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(999)),
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: AutoSizeText(
                    StringFormatter.formatTime(
                      (values.timerState.isOnFocus || values.focusTime >= 0) &&
                              values.breakTime <= 0
                          ? values.focusTime
                          : values.breakTime,
                    ),
                    maxLines: 1,
                    maxFontSize: 68,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
