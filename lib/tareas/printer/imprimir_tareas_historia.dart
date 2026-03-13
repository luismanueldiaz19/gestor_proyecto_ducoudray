import 'dart:io';
import 'package:ducoudray/utils/helpers.dart';
import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import '../../../services/print_services.dart';
import '../../../utils/constants.dart';
import '../model/tarea_historia.dart';

// import '../evaluacion_tabacco.dart';

class ImprimirTareasHistorial {
  ImprimirTareasHistorial();

  static Future<File> generate(List<TareaHistoria> list) async {
    final firmaControlOperacion = MemoryImage(
        (await rootBundle.load(logoApp))
            .buffer
            .asUint8List());

    final imageFirma =
        MemoryImage((await rootBundle.load(firmaLu)).buffer.asUint8List());

    final pageTheme = await _myPageTheme();

    final pdf = Document();
    const style = TextStyle(fontSize: 10, color: PdfColors.grey600);
    pdf.addPage(MultiPage(
      pageTheme: pageTheme,
      build: (context) => [
        buildHeader(
            department: 'Información Impreso por ----',
            imageLogo: firmaControlOperacion,
            fecha: DateTime.now().toString().substring(0, 10),
            text: 'Listado de tareas completados',
            current: currentUsuario?.nombreCompleto),
        tableProducts(list),
      ],
      footer: (context) => buildFooter(imageFirma),
    ));

    return PdfApi.saveDocument(
        name:
            'listado_tarea_completado_${DateTime.now().millisecondsSinceEpoch}_.pdf',
        pdf: pdf);
  }

  static Widget buildHeader(
      {String? department,
      ImageProvider? imageLogo,
      String? fecha,
      String? text,
      String? current,
      double? size}) {
    // const double size = 90;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(imageLogo!, width: size ?? 50, height: size ?? 50),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text ?? 'N/A',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: PdfColors.blueGrey800),
                            ),
                            Text(current ?? 'N/A',
                                style: const TextStyle(
                                    fontSize: 08,
                                    // fontWeight: FontWeight.bold,
                                    color: PdfColors.blueGrey800)),
                            SizedBox(height: 2),
                            Text(
                              department ?? 'N/A',
                              style: const TextStyle(
                                  fontSize: 06,
                                  // fontWeight: FontWeight.bold,
                                  color: PdfColors.blueGrey500),
                            ),
                            SizedBox(height: 2),
                            Text('Fecha: $fecha',
                                style: const TextStyle(
                                    fontSize: 8, color: PdfColors.grey600)),
                          ]))
                ]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(currentEmpresa.nombreEmpresa ?? 'N/A',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: PdfColors.black)),
                SizedBox(height: 2),
                Text('${currentEmpresa.adressEmpressa}',
                    style:
                        const TextStyle(fontSize: 8, color: PdfColors.grey700)),
                Row(children: [
                  Text('Tel: ${currentEmpresa.telefonoEmpresa}',
                      style: const TextStyle(
                          fontSize: 8, color: PdfColors.grey700)),
                  Text('Cel: ${currentEmpresa.celularEmpresa}',
                      style: const TextStyle(
                          fontSize: 8, color: PdfColors.grey700)),
                ]),
              ],
            ),
          ],
        ),
        Divider(color: PdfColors.grey200, thickness: 1),
        SizedBox(height: 10),
      ],
    );
  }

  static Widget tableProducts(List<TareaHistoria> listProduct) {
    final headers = [
      'USUARIO',
      'FECHA',
      'TITULO',
      'Descripción de las tareas'.toUpperCase(),
      'HORAS',
      'REGISTRADO',
      'COMENTARIO',
    ];

    final dataList = listProduct.map((material) {
      return [
        limitarTexto(material.hechoPor ?? '', 10),
        limitarTexto(material.creadoEn ?? '', 10),
        material.titulo?.toUpperCase(),
        material.descripcion?.toUpperCase(),
        getTimeRelationProporcional(material.horas ?? 0.0),
        limitarTexto(material.registedBy ?? '', 10),
        material.feedback ?? '',
      ];
    }).toList();

    // Calcular totales

    return TableHelper.fromTextArray(
      headers: headers,
      data: dataList,
      border: const TableBorder(
        horizontalInside: BorderSide(color: PdfColors.grey300),
        verticalInside: BorderSide(color: PdfColors.grey300),
      ),
      tableWidth: TableWidth.max,
      headerAlignment: Alignment.centerLeft,
      cellStyle: const TextStyle(fontSize: 8),
      oddRowDecoration: const BoxDecoration(color: PdfColors.grey200),
      cellAlignments: {
        0: Alignment.centerLeft, // Usuario
        1: Alignment.center, // Fecha
        2: Alignment.centerLeft, // Titulo
        3: Alignment.centerLeft, // Detalles
        4: Alignment.center, // Horas
        5: Alignment.center, // Tiempo
        6: Alignment.centerLeft, // Comentario
      },

      columnWidths: {
        0: const FixedColumnWidth(50), // Usuario
        1: const FixedColumnWidth(60), // Fecha
        2: const FixedColumnWidth(80), // Titulo
        3: const FlexColumnWidth(3), // Detalles (más ancho)
        4: const FixedColumnWidth(70), // Horas
        5: const FixedColumnWidth(80), // Tiempo
        6: const FlexColumnWidth(2), // Comentario
      },
      headerStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 7, color: PdfColors.white),
      headerDecoration: const BoxDecoration(
          color:
              PdfColors.blueGrey800), // 👇 Aquí defines los tamaños de columnas
    );
  }

  static Widget buildFooter(image) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image, height: 100, width: 100),
        ],
      );

  static Widget buildPaymentInfoRow(String label, String value) {
    const style = TextStyle(fontSize: 8, color: PdfColors.grey600);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: style),
            Text(value, style: style),
          ],
        ),
      ),
    );
  }

  static Future<pdfWidgets.PageTheme> _myPageTheme() async {
    final imageLogoApp =
        MemoryImage((await rootBundle.load(logoApp)).buffer.asUint8List());

    return pdfWidgets.PageTheme(
      orientation: PageOrientation.landscape,
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      buildForeground: (context) {
        return Stack(
          children: [
            pdfWidgets.Positioned(
              right: 20,
              top: 10,
              child: Transform.rotate(
                angle: 45,
                child: Opacity(
                    opacity: 0.2,
                    child: Container(
                        child: Image(imageLogoApp, width: 200, height: 200))),
              ),
            ),
            // pdfWidgets.Positioned(
            //   left: 20,
            //   bottom: 30,
            //   child: Transform.rotate(
            //     angle: 45,
            //     child: Opacity(
            //         opacity: 0.3,
            //         child: Container(
            //             child: Image(imageLogoApp, width: 35, height: 35))),
            //   ),
            // ),
          ],
        );
      },
    );
  }

  static Widget cardCont(
      {String? aboveMaxText,
      String? aboveMaxNum,
      PdfColor? colors,
      String? text}) {
    const styleTittle = TextStyle(fontSize: 10, color: PdfColors.white);
    const style = TextStyle(fontSize: 8, color: PdfColors.black);
    return Row(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(color: colors ?? PdfColors.red300),
        child: Text('${aboveMaxNum ?? 'N/A'} #', style: styleTittle),
      ),
      SizedBox(width: 5),
      Text(text ?? 'N/A', style: style)
    ]);
  }

  static double calcularPorcentajeCalidad({
    required int bajos,
    required int buenos,
    required int altos,
  }) {
    final int total = bajos + buenos + altos;
    if (total == 0) return 0.0;

    final double puntos = (buenos * 1.0) + (altos * 0.0) - (bajos * 0.0);

    final double porcentaje = (puntos / total) * 100;

    return porcentaje;
  }
}
