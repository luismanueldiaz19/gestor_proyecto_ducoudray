import 'package:animate_do/animate_do.dart';
import 'package:ducoudray/palletes/app_colors.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../widgets/menu_drop.dart';
import '../../widgets/validar_screen_available.dart';
import '../proyectos/screens/screen_proyecto.dart';
import '../tareas/screen/screen_page_tarea.dart';
import '../tareas/screen/screen_page_tarea_erp.dart';
import '../utils/helpers.dart';
import 'home/screen_home_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final style = Theme.of(context).textTheme;
    double height = 250;
    final List<HomeButtonModel> homeButtons = [
      // HomeButtonModel(
      //   title: "KPI Gastos",
      //   image: "assets/informe.png",
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => ScreensKpiGasto()),
      //     );
      //   },
      // ),
      if (currentUsuario!.tienePermiso('ver_tarea'))
        HomeButtonModel(
          title: "Tareas",
          image: 'assets/standby.png',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScreenPageTarea()),
            );
          },
        ),
      // Agrega más...
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: currentEmpresa.nombreEmpresa,
                style: style.titleMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        leading: size.width <= 800
            ? IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Image.asset(logoApp, fit: BoxFit.cover),
                ),
              ),
      ),
      drawer: Menudrop(isMobile: true),
      body: ValidarScreenAvailable(
        windows: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElasticInLeft(child: const Menudrop()),
            Expanded(
              child: Column(
                children: [
                  Expanded(flex: 2, child: ScreenPageTareaERP()),

                  const Divider(color: AppColors.secondary, thickness: 0.1),
                  //   flex: 1,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(20),
                  //     child: GridView.builder(
                  //       physics: const BouncingScrollPhysics(),
                  //       itemCount: homeButtons.length,
                  //       shrinkWrap: true,
                  //       gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  //         maxCrossAxisExtent: 225,
                  //         childAspectRatio: size.width <= 600.0 ? 0.9 : 1.1,
                  //         crossAxisSpacing: 40,
                  //         mainAxisSpacing: 20,
                  //       ),
                  //       itemBuilder: (context, index) {
                  //         final item = homeButtons[index];
                  //         return ScreenHomeButtons(
                  //           title: item.title,
                  //           image: item.image,
                  //           onTap: item.onTap,
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  Expanded(flex: 2, child: ScreenProyecto()),
                ],
              ),
            ),
          ],
        ),
        mobile: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: homeButtons.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: size.width <= 600.0 ? 0.9 : 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final item = homeButtons[index];
                    return ScreenHomeButtons(
                      title: item.title,
                      image: item.image,
                      onTap: item.onTap,
                    );
                  },
                ),
              ),
            ),
            identy(context),
          ],
        ),
      ),
    );
  }
}
