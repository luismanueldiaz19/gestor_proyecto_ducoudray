import 'package:ducoudray/proyectos/widgets/add_propuesta_to_proyecto.dart';
import 'package:flutter/material.dart';

import '../widgets/add_cotizacion_to_proyecto.dart';
import '../widgets/add_equipo_to_proyecto.dart';
import '../widgets/add_gasto_to_projecto.dart';
import '../widgets/add_oportunidades_to_proyecto.dart';

class AddProyectos extends StatefulWidget {
  const AddProyectos({super.key});

  @override
  State createState() => _AddProyectosState();
}

class _AddProyectosState extends State<AddProyectos> {
  int _currentStep = 0;

  // Controladores básicos
  final _nombreProyectoController = TextEditingController();
  final _alcanceController = TextEditingController();
  final _entregablesController = TextEditingController();
  final _cronogramaController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  final _fechaFinController = TextEditingController();

  // Datos dinámicos
  List<Map<String, dynamic>> equipo = [];
  List<Map<String, dynamic>> cotizaciones = [];
  List<Map<String, dynamic>> gastos = [];
  List<Map<String, dynamic>> horasInvertidas = [];
  List<Map<String, dynamic>> facturacion = [];
  List<Map<String, dynamic>> servicios = [];
  List<Map<String, dynamic>> propuestas = [];
  List<Map<String, dynamic>> oportunidades = [];

  Future<void> enviarProyecto() async {
    // Validación final antes de enviar
    if (_nombreProyectoController.text.isEmpty ||
        equipo.isEmpty ||
        cotizaciones.isEmpty ||
        gastos.isEmpty ||
        facturacion.isEmpty ||
        servicios.isEmpty ||
        propuestas.isEmpty ||
        oportunidades.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("El formulario está incompleto")));
      return;
    }

    final Map<String, dynamic> data = {
      "cliente_id": 1,
      "proyecto": {
        "nombre": _nombreProyectoController.text,
        "alcance": _alcanceController.text,
        "entregables": _entregablesController.text,
        "cronograma": _cronogramaController.text,
        "fecha_inicio": _fechaInicioController.text,
        "fecha_fin": _fechaFinController.text,
      },
      "equipo": equipo,
      "cotizaciones": cotizaciones,
      "gastos": gastos,
      "horas_invertidas": horasInvertidas,
      "facturacion": facturacion,
      "servicios_contratados": servicios,
      "propuestas": propuestas,
      "oportunidades": oportunidades,
    };

    print(data);

    // final response = await http.post(
    //   Uri.parse(
    //     "http://localhost/ducoudray/proyectos/agregar_proyecto_completo.php",
    //   ),
    //   headers: {"Content-Type": "application/json"},
    //   body: jsonEncode(data),
    // );

    // if (response.statusCode == 200) {
    //   final result = jsonDecode(response.body);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Respuesta: ${result['message']}")),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Error al enviar: ${response.statusCode}")),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro de Proyecto ERP")),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          switch (_currentStep) {
            case 0:
              if (_nombreProyectoController.text.isEmpty ||
                  _alcanceController.text.isEmpty ||
                  _entregablesController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Completa todos los campos del proyecto"),
                    duration: Durations.short3,
                  ),
                );
                return;
              }
              break;
            case 1:
              if (equipo.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Agrega al menos un miembro al equipo"),
                    duration: Durations.short3,
                  ),
                );
                return;
              }
              break;
            case 2:
              if (cotizaciones.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Agrega al menos una cotización"),
                    duration: Durations.short3,
                  ),
                );
                return;
              }
              break;
            case 3:
              if (gastos.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Agrega al menos un gasto"),
                    duration: Durations.short3,
                  ),
                );
                return;
              }
              break;

            case 4:
              if (propuestas.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Agrega al menos una propuesta"),
                    duration: Durations.short3,
                  ),
                );
                return;
              }
              break;

            case 5:
              if (oportunidades.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Agrega al menos una oportunidad"),
                    duration: Durations.short3,
                  ),
                );
                return;
              }
              break;
          }

          if (_currentStep < 6) {
            setState(() => _currentStep += 1);
          } else {
            enviarProyecto();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        steps: [
          Step(
            title: Text("Proyecto"),
            content: Column(
              children: [
                TextField(
                  controller: _nombreProyectoController,
                  decoration: InputDecoration(labelText: "Nombre"),
                ),
                TextField(
                  controller: _alcanceController,
                  decoration: InputDecoration(labelText: "Alcance"),
                ),
                TextField(
                  controller: _entregablesController,
                  decoration: InputDecoration(labelText: "Entregables"),
                ),
                TextField(
                  controller: _cronogramaController,
                  decoration: InputDecoration(labelText: "Cronograma"),
                ),
                TextField(
                  controller: _fechaInicioController,
                  decoration: InputDecoration(labelText: "Fecha inicio"),
                ),
                TextField(
                  controller: _fechaFinController,
                  decoration: InputDecoration(labelText: "Fecha fin"),
                ),
              ],
            ),
          ),
          Step(
            title: Text("Equipo"),
            content: AddEquipoToProyecto(
              onDelete: (value) {
                equipo.remove(value);
                setState(() {});
              },
              onEquipoChanged: (value) {
                equipo = value;
                setState(() {});

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Equipo demo agregado")));
              },
            ),
          ),
          Step(
            title: Text("Cotizaciones"),
            content: AddCotizacionToProyecto(
              onCotizacionChanged: (nuevasCotizaciones) {
                setState(() {
                  cotizaciones = nuevasCotizaciones;
                });
              },
            ),

            // ElevatedButton(
            //   onPressed: () {
            //     cotizaciones.add({
            //       "descripcion": "Cotización inicial",
            //       "monto": 150000,
            //       "estado": "Pendiente",
            //       "fecha": "2026-03-10",
            //     });
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(content: Text("Cotización demo agregada")),
            //     );
            //   },
            //   child: Text("Agregar cotización demo"),
            // ),
          ),
          Step(
            title: Text("Gastos"),
            content: AddGastoToProyecto(
              onGastoChanged: (nuevosGastos) {
                setState(() {
                  gastos = nuevosGastos;
                });
              },
            ),
          ),
          Step(
            title: Text("Propuestas"),
            content: AddPropuestaToProyecto(
              onPropuestaChanged: (nuevasPropuestas) {
                setState(() {
                  propuestas = nuevasPropuestas;
                });
              },
            ),
          ),
          Step(
            title: Text("Oportunidades"),
            content: AddOportunidadToProyecto(
              onOportunidadChanged: (nuevasOportunidades) {
                setState(() {
                  oportunidades = nuevasOportunidades;
                });
              },
            ),
          ),

          Step(
            title: Text("Finalizar"),
            content: ElevatedButton(
              onPressed: enviarProyecto,
              child: Text("Enviar a API"),
            ),
          ),
        ],
      ),
    );
  }
}
