import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../model/usuario.dart';
import '../palletes/app_colors.dart';
import '../repositories/usuarios_services.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_loading.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UsuariosServices permissions = UsuariosServices();
  late TextEditingController controllerUsuario = TextEditingController(
    text: 'ludeveloper',
  );
  late TextEditingController controllerClave = TextEditingController(
    text: '199512',
  );

  bool? obscureText = true;
  final FocusNode _focusNode = FocusNode();
  bool isLoading = false;

  void signup(context) async {
    if (controllerUsuario.text.isEmpty || controllerClave.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hay campos vacios'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      Usuario? value = await permissions.loginUser(context, {
        'usuario': controllerUsuario.text.toLowerCase().trim(),
        'contrasena': controllerClave.text.trim(),
      });
      if (value != null) {
        if (value.status == 'true' || value.status == 't') {
          // print(
          //     'el usuario tiene el rol de logistica : ${value.tienePermiso('logistica')}');
          currentUsuario = value;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false,
          );
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tu usuario esta deshactivado'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // throw Exception("Error al cargar roles");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    controllerClave.dispose();
    controllerUsuario.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final curve = Curves.easeInOutExpo;
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CustomLoading(
                text: 'Validando Usuario, Espere ...',
                scale: 8,
              ),
            )
          : Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF9F9F9), Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                const TopCurve(),
                const BottomCurve(),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 300, // tamaño mínimo
                        maxWidth: 450, // tamaño máximo (NO crecerá más)
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            BounceInDown(
                              curve: curve,
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Image.asset(
                                  logoApp,
                                  height: 100,
                                  width: 250,
                                ),
                              ),
                            ),
                            // const SizedBox(height: 20),
                            textFieldWidgetUI(
                              label: 'Usuario',
                              controller: controllerUsuario,
                              onEditingComplete: () {
                                _focusNode.nextFocus();
                              },
                              hintText: 'Usuario',
                            ),
                            textFieldWidgetUI(
                              controller: controllerClave,
                              focusNode: _focusNode,
                              hintText: 'Password',
                              onEditingComplete: () => signup(context),
                              label: 'Password',
                              obscureText: obscureText,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Quiere mostrar contraseña ?',
                                  style: style.bodySmall!.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      obscureText = !obscureText!;
                                    });
                                  },
                                  child: Text(
                                    'click Aqui!',
                                    style: style.bodySmall!.copyWith(
                                      color: AppColors.tealGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            ZoomIn(
                              curve: curve,
                              child: CustomLoginButton(
                                onPressed: () => signup(context),
                                colorButton: AppColors.tealGreen,
                              ),
                            ),
                            const SizedBox(height: 5),
                            BounceInUp(
                              curve: curve,
                              child: Image.asset(
                                'assets/bottom_logo.png',
                                height: 60,
                                width: 150,
                                color: AppColors.corporateBrown,
                              ),
                            ),
                            // const SizedBox(height: 15),
                            identy(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class BottomCurve extends StatelessWidget {
  const BottomCurve({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipPath(
        clipper: BottomClipper(),
        child: Container(
          height: 100,
          color: AppColors.secondary, // Azul inferior
        ),
      ),
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 30);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopCurve extends StatelessWidget {
  const TopCurve({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopClipper(),
      child: Container(
        height: 140,
        color: AppColors.primary, // Rojo techo
      ),
    );
  }
}

class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
