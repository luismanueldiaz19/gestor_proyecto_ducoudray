import 'package:ducoudray/utils/helpers.dart';
import 'package:flutter/material.dart';

import '../model/empresa_local.dart';
import '../model/usuario.dart';

// KVM ID: 61830
// Main IP: 23.231.65.39
// U: root
// P: u38JZ.!rZaDb50

// generador manuale
//// http://localhost/ducoudray/manual_table_crud_generator.php?tabla=servicios_contratados
/// post g:  clave de postgres usuario : toqxih-kAfhyf-xagha6

const String appName = 'Ducoudray & Asociados';

Usuario? currentUsuario = Usuario(nombreCompleto: '', usuario: '');
// const ipLocal = '23.231.65.39';
///  otra ip :  104.206.57.61

// const ipLocal = '104.206.57.61';
const ipLocal = 'localhost';
//update  proyecto_earth set acess = 'p' where id_proyecto_earth = '74db3456-96b6-46bd-9fb2-4d47de89b8ac';

// Update usuario set access = 'abcdefghijklmnñopqrstuvwxyz'  where usuario_id = '5f41e112-96db-4b50-8168-bd3e83cfbe92';  elvi
// Update usuario set access = 'abcdefghijklmnñopqrstuvwxyz'  where usuario_id = '4ef282f4-8cf7-40b2-bf1b-5eaea98b362e';
const pathHost = 'ducoudray';
// 3u6Q!-D4WvXu7u Token
// LC!OU6)tJ0bbz
// kYxgib-nicfa0-sesnib
const double defaultPadding = 16.0;
// const String apiBaseUrl = 'https://api.myapp.com/';
const String logoApp = 'assets/logo_app.png';
// const String vertical = "imagen/vertical.png";
const double kwidth = 250;

String firmaLu = 'assets/logo.jpeg';

String developer = '©Created by LWADER SOFT';

List<String> estadoPrestamo = ['pendiente', 'pagado', 'vencido'];
List<String> modoPagoPrestamo = ['semanal', 'quincenal', 'mensual'];

String textConfirmacion = '👉🏼Esta seguro realizar ? 👈🏼';
String eliminarMjs = '🥺Esta seguro de eliminar🥺';
// String ActionMjs = '👉🏼Esta seguro de confirmar el tiempo ?👈🏼';
String confirmarMjs =
    '👉🏼Esta seguro de confirmar el despacho de las facturas?👈🏼';
final kbuttonStyle = ButtonStyle(
  shape: WidgetStateProperty.resolveWith(
    (states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
  ),
);

EmpresaLocal currentEmpresa = EmpresaLocal(
  adressEmpressa: 'Direccion N/A',
  celularEmpresa: '(xxx)-xxx-xxx',
  nombreEmpresa: 'Ducoudray & Asociados',
  oficinaEmpres: 'xxxxx@gmail.com',
  rncEmpresa: 'xxxxx-x',
  telefonoEmpresa: '(000)-000-0000',
  nCFEmpresa: 'xxx',
  correoEmpresa: 'x@gmail.com',
);

///token kYxgib-nicfa0-sesnib

// ///Color(0xffabffdb)
// const Color colorsGreen = Color.fromARGB(255, 74, 235, 195);
// const Color colorsGreenGrey = Color.fromARGB(255, 94, 245, 207);

List<String> listTypeVehiculo = [
  'Sedán',
  'Hatchback',
  'Coupé',
  'Convertible',
  'SUV',
  'Pickup',
  'Automovil',
  'Camioneta',
  'Van',
];
List<String> estadoOfRentCar = ['rentado', 'disponible', 'fuera de servicios'];
List<String> listEstadoIncidencia = [
  'pendiente',
  'aprobada',
  'rechazada',
  'finalizado',
  'planificado',
];
// access: bhdgiaefc,
// Available Animations
// FadeIn Animations
// FadeIn
// FadeInDown
// FadeInDownBig
// FadeInUp
// FadeInUpBig
// FadeInLeft
// FadeInLeftBig
// FadeInRight
// FadeInRightBig
// FadeOut Animations
// FadeOut
// FadeOutDown
// FadeOutDownBig
// FadeOutUp
// FadeOutUpBig
// FadeOutLeft
// FadeOutLeftBig
// FadeOutRight
// FadeOutRightBig
// BounceIn Animations
// BounceInDown
// BounceInUp
// BounceInLeft
// BounceInRight
// ElasticIn Animations
// ElasticIn
// ElasticInDown
// ElasticInUp
// ElasticInLeft
// ElasticInRight
// SlideIns Animations
// SlideInDown
// SlideInUp
// SlideInLeft
// SlideInRight
// FlipIn Animations
// FlipInX
// FlipInY
// Zooms
// ZoomIn
// ZoomOut
// SpecialIn Animations
// JelloIn
// Attention Seeker
// All of the following animations could be infinite with a property called infinite (type Bool)

// Bounce
// Dance
// Flash
// Pulse
// Roulette
// ShakeX
// ShakeY
// Spin
// SpinPerfect
// Swing
// Example: 01-Basic

Future<String?> seleccionarEstado(
  BuildContext context, {
  List<String>? list = const [
    'pendiente',
    'aprobada',
    'rechazada',
    'finalizado',
  ],
}) async {
  return await showModalBottomSheet<String>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(18),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Seleccionar Estado",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ...list!.map(
                (estado) => TextButton(
                  child: buildEstadoBadge(estado ?? '-'),
                  onPressed: () =>
                      Navigator.pop(context, estado), // << devuelve valor
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
