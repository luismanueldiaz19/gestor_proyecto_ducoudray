import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'palletes/app_colors.dart';
import 'provider/cliente_provider.dart';

import 'routes.dart';
import 'tareas/provider_tareas/tarea_provider.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar datos de localización para español
  await initializeDateFormatting('es_ES', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClienteProvider()),
        ChangeNotifierProvider(create: (_) => TareaProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return MaterialApp(
      title: currentEmpresa.nombreEmpresa.toString(),
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: Colors.black,
          titleTextStyle: style.bodyMedium?.copyWith(color: Colors.black),
          scrolledUnderElevation: 0.0,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ),
      initialRoute: Routes.splashScreen,
      onGenerateRoute: Routes.generateRoute,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
