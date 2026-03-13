import 'package:ducoudray/palletes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../utils/constants.dart';
import 'screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthentication(context);
  }

  // Método para revisar si el usuario está autenticado
  Future<void> _checkAuthentication(context) async {
    // print(
    //     'splash screen builder ... initialization => _checkAuthentication(context)');
    // bool? isAuthenticated = await authService.isAuthenticated();

    // if (isAuthenticated) {
    //   String? token = await AuthService().getToken();

    //   if (token != null && token.isNotEmpty) {
    //     try {
    //       currentUsuario = User.fromJson(jsonDecode(token));
    //     } catch (e) {
    //       print('Error al decodificar el token: $e');
    //       currentUsuario = null;
    //     }
    //   } else {
    //     print('Token no válido o vacío');
    //     currentUsuario = null;
    //   }

    //   // Simulamos un pequeño retraso para que el splash sea visible por un tiempo
    //   await Future.delayed(const Duration(seconds: 2));
    //   if (currentUsuario != null) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => MyHomePage()),
    //     );
    //   } else {
    //     await Future.delayed(const Duration(seconds: 2));
    //     print('Entidad del usuario no correcta.');
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) => const LoginScreen()));
    //   }
    // } else {
    //   print('there is not user logged... $isAuthenticated');
    await Future.delayed(const Duration(seconds: 2));
    // Si no está autenticado, lo rediriges a la pantalla Login
    // }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElasticIn(
          curve: Curves.elasticInOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(logoApp, height: 100),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  color: AppColors.primary,
                ),
              ), // Indicador de carga
              const SizedBox(height: 20),
              Text(
                'Verificando autenticación del usuario...',
                style: style.titleMedium?.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
