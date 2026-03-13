import 'package:animate_do/animate_do.dart';
import 'package:ducoudray/palletes/app_colors.dart';
import 'package:ducoudray/proyectos/screens/add_proyectos.dart';
import 'package:ducoudray/screens/client/add_client.dart';
import 'package:ducoudray/screens/client/screen_list_cliente.dart';
import 'package:ducoudray/utils/constants.dart';
import 'package:flutter/material.dart';

import '../screens/permissions/add_usuario.dart';
import '../screens/permissions/screen_permission.dart';
import '../screens/permissions/screen_usuarios.dart';
import '../screens/profile/screen_profile.dart';
import '../screens/proveedores/add_proveedores.dart';
import '../screens/proveedores/screen_proveedores.dart';

import '../splash_screen.dart';
import '../tareas/screen/add_tarea.dart';
import '../tareas/screen/screen_page_tarea.dart';
import '../tareas/screen/screen_page_tarea_record.dart';
import 'button_menu_drawer.dart';

// import '../utils/helpers.dart';

class Menudrop extends StatefulWidget {
  const Menudrop({super.key, this.isMobile = false});
  final bool isMobile;

  @override
  State<StatefulWidget> createState() => _MenudropState();
}

class _MenudropState extends State<Menudrop> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final style = Theme.of(context).textTheme;

    final double menuWidth = widget.isMobile
        ? size.width *
              0.7 // 📱 En móvil: 70% del ancho
        : (size.width > 1400
              ? 280 // 🖥️ Pantallas grandes
              : 240); // 💻 Escritorio estándar

    final double fontSize = widget.isMobile ? 15 : 14;
    final double fontSizeSubtitle = widget.isMobile ? 15 : 12;

    return Container(
      color: AppColors.surface,
      height: size.height,
      width: menuWidth,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.isMobile
                ? BounceInDown(
                    child: Container(
                      // height: 100,
                      // width: 100,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      child: Image.asset(logoApp, fit: BoxFit.cover, scale: 10),
                    ),
                  )
                : const SizedBox(height: 10),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  showTrailingIcon: false,
                  subtitle: Text(
                    'Ver y gestionar Cuenta',
                    style: style.bodySmall?.copyWith(
                      color: Colors.black54,
                      fontSize: fontSizeSubtitle,
                    ),
                  ),
                  title: Text(
                    'Mi Cuenta',
                    style: style.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: fontSize,
                    ),
                  ),
                  children: [
                    MyWidgetButton(
                      icon: Icons.home_outlined,
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SplashScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      textButton: 'Inicio',
                    ),
                    MyWidgetButton(
                      icon: Icons.person_3_outlined,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PerfilUsuarioPage(usuario: currentUsuario!),
                          ),
                        );
                      },
                      textButton: 'Mi Perfil',
                    ),
                    MyWidgetButton(
                      icon: Icons.output_outlined,
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SplashScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      textButton: 'Cerrar Sección',
                      colorIcon: Colors.red,
                      textColor: Colors.redAccent.shade700,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                      borderRadius: 10,
                      hoverColor: Colors.redAccent.withValues(alpha: 0.2),
                    ),
                  ],
                ),
              ),
            ),
            if (currentUsuario!.tienePermiso('ver_proyectos'))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    showTrailingIcon: false,
                    subtitle: Text(
                      'Ver y gestionar Proyectos',
                      style: style.bodySmall?.copyWith(
                        color: Colors.black54,
                        fontSize: fontSizeSubtitle,
                      ),
                    ),
                    title: Text(
                      'Proyectos',
                      style: style.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: fontSize,
                      ),
                    ),
                    children: [
                      MyWidgetButton(
                        icon: Icons.add,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProyectos(),
                            ),
                          );
                        },
                        textButton: 'Agregar Proyectos',
                      ),
                      // MyWidgetButton(
                      //   icon: Icons.list_alt_sharp,
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => ScreenProveedores(),
                      //       ),
                      //     );
                      //   },
                      //   textButton: 'Proveedores',
                      // ),
                      // MyWidgetButton(
                      //   icon: Icons.traffic_outlined,
                      //   onPressed: () {
                      //     Navigator.push(context,
                      //         MaterialPageRoute(builder: (_) => ScreenVisitas()));
                      //   },
                      //   textButton: 'Viajes De Vehiculos',
                      //   colorIcon: Colors.blue,
                      //   textColor: Colors.blueAccent.shade700,
                      //   fontSize: 15,
                      //   fontWeight: FontWeight.bold,
                      //   backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
                      //   borderRadius: 10,
                      //   hoverColor: Colors.blueAccent.withValues(alpha: 0.2),
                      // ),
                      // // MyWidgetButton(
                      // //     icon: Icons.car_crash_outlined,
                      // //     onPressed: () {
                      // //       Navigator.push(
                      // //         context,
                      // //         MaterialPageRoute(
                      // //           builder: (context) => ScreenMantenimiento(),
                      // //         ),
                      // //       );
                      // //     },
                      // //     textButton: 'Centro Reportes'),

                      // //CuadreCajaPage
                    ],
                  ),
                ),
              ),

            if (currentUsuario!.tienePermiso('ver_tarea'))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    showTrailingIcon: false,
                    subtitle: Text(
                      'Ver y gestionar Tareas',
                      style: style.bodySmall?.copyWith(
                        color: Colors.black54,
                        fontSize: fontSizeSubtitle,
                      ),
                    ),
                    title: Text(
                      'Tareas',
                      style: style.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: fontSize,
                      ),
                    ),
                    children: [
                      if (currentUsuario!.tienePermiso('crear_tarea'))
                        MyWidgetButton(
                          icon: Icons.add,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTarea(),
                              ),
                            );
                          },
                          textButton: 'Agregar Tareas',
                        ),
                      MyWidgetButton(
                        icon: Icons.task_outlined,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScreenPageTarea(),
                            ),
                          );
                        },
                        textButton: 'Tareas',
                      ),
                      MyWidgetButton(
                        icon: Icons.task_alt_outlined,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScreenPageTareaRecord(),
                            ),
                          );
                        },
                        textButton: 'Historial Tareas',
                        colorIcon: Colors.green,
                        textColor: Colors.greenAccent.shade700,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.greenAccent.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: 10,
                        hoverColor: Colors.greenAccent.withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                ),
              ),
            if (currentUsuario!.tienePermiso('ver_clientes'))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    showTrailingIcon: false,
                    subtitle: Text(
                      'Ver y gestionar Clientes',
                      style: style.bodySmall?.copyWith(
                        color: Colors.black54,
                        fontSize: fontSizeSubtitle,
                      ),
                    ),
                    title: Text(
                      'Clientes',
                      style: style.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: fontSize,
                      ),
                    ),
                    children: [
                      if (currentUsuario!.tienePermiso('crear_clientes'))
                        MyWidgetButton(
                          icon: Icons.person_add_alt_outlined,
                          onPressed: () {
                            mostrarDialogAgregarCliente(context);
                          },
                          textButton: 'Agregar Clientes',
                        ),
                      MyWidgetButton(
                        icon: Icons.co_present_outlined,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScreenListCliente(),
                            ),
                          );
                        },
                        textButton: 'Clientes',
                      ),

                      //CuadreCajaPage
                    ],
                  ),
                ),
              ),
            if (currentUsuario!.tienePermiso('ver_proveedores'))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    showTrailingIcon: false,
                    subtitle: Text(
                      'Ver y gestionar Proveedores',
                      style: style.bodySmall?.copyWith(
                        color: Colors.black54,
                        fontSize: fontSizeSubtitle,
                      ),
                    ),
                    title: Text(
                      'Proveedores',
                      style: style.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: fontSize,
                      ),
                    ),
                    children: [
                      if (currentUsuario!.tienePermiso('crear_proveedores'))
                        MyWidgetButton(
                          icon: Icons.add,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddProveedores(),
                              ),
                            );
                          },
                          textButton: 'Agregar Proveedor',
                        ),
                      MyWidgetButton(
                        icon: Icons.list_alt_sharp,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScreenProveedores(),
                            ),
                          );
                        },
                        textButton: 'Proveedores',
                      ),
                      // MyWidgetButton(
                      //   icon: Icons.traffic_outlined,
                      //   onPressed: () {
                      //     Navigator.push(context,
                      //         MaterialPageRoute(builder: (_) => ScreenVisitas()));
                      //   },
                      //   textButton: 'Viajes De Vehiculos',
                      //   colorIcon: Colors.blue,
                      //   textColor: Colors.blueAccent.shade700,
                      //   fontSize: 15,
                      //   fontWeight: FontWeight.bold,
                      //   backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
                      //   borderRadius: 10,
                      //   hoverColor: Colors.blueAccent.withValues(alpha: 0.2),
                      // ),
                      // // MyWidgetButton(
                      // //     icon: Icons.car_crash_outlined,
                      // //     onPressed: () {
                      // //       Navigator.push(
                      // //         context,
                      // //         MaterialPageRoute(
                      // //           builder: (context) => ScreenMantenimiento(),
                      // //         ),
                      // //       );
                      // //     },
                      // //     textButton: 'Centro Reportes'),

                      // //CuadreCajaPage
                    ],
                  ),
                ),
              ),
            if (currentUsuario!.tienePermiso('administrador'))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    showTrailingIcon: false,
                    subtitle: Text(
                      'Ver y gestionar Usuarios/Permisos',
                      style: style.bodySmall?.copyWith(
                        color: Colors.black54,
                        fontSize: fontSizeSubtitle,
                      ),
                    ),
                    title: Text(
                      'Usuarios/Permisos',
                      style: style.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: fontSize,
                      ),
                    ),
                    children: [
                      MyWidgetButton(
                        icon: Icons.person_add_alt_outlined,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddUsuario()),
                          );
                        },
                        textButton: 'Agregar Usuario',
                      ),
                      MyWidgetButton(
                        icon: Icons.security_outlined,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ScreenPermission(),
                            ),
                          );
                        },
                        textButton: 'Roles y Permisos',
                      ),
                      MyWidgetButton(
                        icon: Icons.groups_2_outlined,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ScreenUsuarios()),
                          );
                        },
                        textButton: 'Mis Usuarios',
                        colorIcon: Colors.pink,
                        textColor: Colors.pinkAccent.shade700,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.pinkAccent.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: 10,
                        hoverColor: Colors.pinkAccent.withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
