import 'package:flutter/material.dart';
import 'package:orodomop/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ToggleThemeButton extends StatelessWidget {
  const ToggleThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ThemeProvider, bool>(
      selector: (context, model) => model.isLightTheme,
      builder: (context, isLightTheme, child) {
        return Switch(
          onChanged: (_) {
            context.read<ThemeProvider>().toggleTheme();
          },
          value: !isLightTheme,
        );
      },
    );
  }
}
