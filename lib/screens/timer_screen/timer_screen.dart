import 'package:flutter/material.dart';
import 'package:orodomop/services/foreground/service_manager.dart';
import 'package:orodomop/providers/timer_provider.dart';
import 'package:orodomop/providers/settings_provider.dart';

import 'package:orodomop/screens/timer_screen/orodomop/timer_control_row.dart'
    as orodomop;
import 'package:orodomop/screens/timer_screen/pomodoro/timer_control_row.dart'
    as pomodoro;

import 'package:orodomop/screens/timer_screen/widgets/cycle_timer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  void initState() {
    super.initState();
    // Add a callback to receive data sent from the TaskHandler.
    FlutterForegroundTask.addTaskDataCallback(ServiceManager.onReceiveTaskData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Request permissions and initialize the service.
      ServiceManager.requestPermissions();
      ServiceManager.initService();
      context.read<TimerProvider>().onAppResumed();
    });
  }

  @override
  void dispose() {
    // Remove a callback to receive data sent from the TaskHandler.
    FlutterForegroundTask.removeTaskDataCallback(
      ServiceManager.onReceiveTaskData,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: Scaffold(
        appBar: TimerScreenAppBar(),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Selector<SettingsProvider, ({bool usePomodoro})>(
                selector: (context, model) => (usePomodoro: model.usePomodoro),
                builder: (context, value, child) {
                  return Center(
                    child: ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(
                        overscroll: false,
                      ),
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onDoubleTap: () {
                                  Navigator.pushNamed(context, '/settings');
                                },
                                child: CycleTimer(),
                              ),
                              value.usePomodoro
                                  ? pomodoro.TimerControlRow()
                                  : orodomop.TimerControlRow(),
                              SizedBox(
                                height: Scaffold.of(context).appBarMaxHeight,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class TimerScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TimerScreenAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return Selector<SettingsProvider, bool>(
      selector: (_, settings) => settings.hideSettingsButton,
      builder: (context, hideSettingsButton, child) {
        return AppBar(
          actions: [
            hideSettingsButton
                ? SizedBox.shrink()
                : IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
          ],
        );
      },
    );
  }
}
