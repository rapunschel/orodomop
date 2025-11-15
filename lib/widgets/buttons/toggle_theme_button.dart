import 'package:flutter/material.dart';
import 'package:orodomop/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ToggleThemeButton extends StatelessWidget {
  const ToggleThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeModel = context.read<ThemeProvider>();

    return Selector<ThemeProvider, bool>(
      selector: (context, model) => model.isLightTheme,
      builder: (context, isLightTheme, child) {
        return TextButton(
          onPressed: () {
            themeModel.toggleTheme();
          },
          child: Text(
            themeModel.isLightTheme ? "Dark mode" : "Light mode",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }
}
