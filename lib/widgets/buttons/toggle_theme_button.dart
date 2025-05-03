import 'package:flutter/material.dart';
import 'package:orodomop/models/theme_model.dart';
import 'package:provider/provider.dart';

class ToggleThemeButton extends StatelessWidget {
  const ToggleThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeModel themeModel = context.read<ThemeModel>();

    return Selector<ThemeModel, bool>(
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
