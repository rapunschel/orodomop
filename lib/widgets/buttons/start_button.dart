import 'package:flutter/material.dart';
import 'package:orodomop/providers/timer_provider.dart';
import 'package:provider/provider.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<TimerProvider>().startFocusTimer();
      },
      child: Text("Start"),
    );
  }
}
