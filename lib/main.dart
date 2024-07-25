import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:windows_wallpaper/view/home_view.dart';

void main() => runApp(const Root());

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: 'Windows Wallpaper',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: lightDynamic ??
                ColorScheme.fromSwatch(primarySwatch: Colors.purple),
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic ?? const ColorScheme.dark(),
          ),
          themeMode: ThemeMode.system,
          home: const HomeView(),
        );
      },
    );
  }
}
