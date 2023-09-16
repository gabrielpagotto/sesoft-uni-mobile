import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesoft_uni_mobile/src/helpers/providers/app_settings.dart';
import 'package:sesoft_uni_mobile/src/modules/settings/settings_controller.dart';
import 'package:sesoft_uni_mobile/src/widgets/sesoft_scaffold.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  // ignore: constant_identifier_names
  static const ROUTE = '/settigns';

  @override
  Widget build(BuildContext context) {
    return SesoftScaffold(
      titleText: "Configurações",
      body: ListView(
        children: [
          Consumer(builder: (context, ref, _) {
            return SwitchListTile.adaptive(
              value: ref.watch(appSettingsProvider.select((value) => value.themeMode == ThemeMode.system)),
              onChanged: (v) => ref.read(settingsControllerProvider.notifier).toggleThemeModeSystem(),
              title: const Text('Cores do sistema'),
            );
          }),
          const Divider(height: 0),
          Consumer(builder: (context, ref, _) {
            final themeMode = ref.watch(appSettingsProvider.select((value) => value.themeMode));
            return SwitchListTile.adaptive(
              title: const Text('Utilizar tema escuro'),
              value: themeMode == ThemeMode.system ? MediaQuery.of(context).platformBrightness == Brightness.dark : themeMode == ThemeMode.dark,
              onChanged: themeMode == ThemeMode.system ? null : (v) => ref.read(settingsControllerProvider.notifier).toggleThemeModeDark(),
            );
          })
        ],
      ),
    );
  }
}
