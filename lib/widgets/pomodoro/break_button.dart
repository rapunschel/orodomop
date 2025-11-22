import 'package:flutter/material.dart';
import 'package:orodomop/providers/timer_provider.dart';
import 'package:provider/provider.dart';

class BreakButton extends StatelessWidget {
  const BreakButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<TimerProvider>().startBreakTimer();
      },
      child: Text("Break"),
    );
  }
}
