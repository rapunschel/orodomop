import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:orodomop/models/timer_model.dart';
import 'package:provider/provider.dart';
import 'package:orodomop/models/string_formatter.dart';
import 'package:glowy_borders/glowy_borders.dart';

class CycleTimer extends StatelessWidget {
  const CycleTimer({super.key});

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
        return AnimatedGradientBorder(
          borderSize: 3,
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
                child: AutoSizeText(
                  StringFormatter.formatTime(
                    breakTime > 0 ? breakTime : focusTime,
                  ),
                  maxLines: 1,
                  maxFontSize: 68,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
