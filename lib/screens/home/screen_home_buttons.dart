import 'package:ducoudray/palletes/app_colors.dart';
import 'package:flutter/material.dart';

class ScreenHomeButtons extends StatefulWidget {
  const ScreenHomeButtons({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });
  final String title;
  final String image;
  final VoidCallback onTap;
  @override
  State createState() => _ScreenHomeButtonsState();
}

class _ScreenHomeButtonsState extends State<ScreenHomeButtons> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        margin: const EdgeInsets.all(0),
        transform:
            _isHovered ? (Matrix4.identity()..scale(1.09)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.blueGrey.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Stack(
          children: [
            // fondo
            Positioned.fill(
              child: GestureDetector(
                onTap: widget.onTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(widget.image, fit: BoxFit.cover),
                ),
              ),
            ),

            // indicadores
            Positioned(
              top: 10,
              left: 10,
              child: Column(
                children: [
                  // buildIndicator(widget.current.isOperate ?? 0, Colors.green),
                  // buildIndicator(widget.current.statu ?? 0, Colors.red),
                  // buildIndicator(
                  //   widget.current.isMaintenance ?? 0,
                  //   Colors.purple,
                  // ),
                ],
              ),
            ),

            // textos abajo
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.error, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text(
                    //   widget.current.nameDepart ?? 'N/A',
                    //   style: style.bodyLarge?.copyWith(
                    //     color: const Color.fromARGB(255, 0, 5, 5),
                    //   ),
                    // ),
                    Tooltip(
                      message: "Nombre del button",
                      child: Text(
                        widget.title,
                        style: style.bodySmall?.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.only(left: 0, right: 0),
                    //   child: Tooltip(
                    //     message: 'Total de maquinas : ',
                    //     child: Text(
                    //       'Total MQ: ',
                    //       style: TextStyle(
                    //         fontSize: 10,
                    //         color: Colors.black87,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),

            // capa de deshabilitado según tipo (si aplica)
            // if (!shouldShow(currentData, widget.current))
            //   Positioned.fill(
            //     child: Container(color: Colors.grey.withValues(alpha: 0.5)),
            //   ),
          ],
        ),
      ),
    );
  }
}

class HomeButtonModel {
  final String title;
  final String image;
  final VoidCallback onTap;

  HomeButtonModel({
    required this.title,
    required this.image,
    required this.onTap,
  });
}
