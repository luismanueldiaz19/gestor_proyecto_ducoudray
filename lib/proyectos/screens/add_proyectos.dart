import 'package:ducoudray/model/cliente.dart';
import 'package:ducoudray/proyectos/provider/provider_proyecto.dart';
import 'package:ducoudray/proyectos/widgets/add_propuesta_to_proyecto.dart';
import 'package:ducoudray/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../repositories/cliente_service.dart';
import '../../widgets/window_list_selector.dart';
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
  final TextEditingController contClient = TextEditingController();
  List<Cliente> listClientsFilter = [];

  Future getClient() async {
    List<Cliente> list = await ClienteService.fetchClientes();
    listClientsFilter = list;
  }

  @override
  void initState() {
    super.initState();
    getClient();
  }

  // Controladores básicos
  final _nombreProyectoController = TextEditingController();
  final _alcanceController = TextEditingController();
  final _entregablesController = TextEditingController();
  final _cronogramaController = TextEditingController();
  final _fechaInicioController = TextEditingController();
  final _fechaFinController = TextEditingController();
  final _costoController = TextEditingController();

  // Datos dinámicos
  List<Map<String, dynamic>> equipo = [];
  List<Map<String, dynamic>> cotizaciones = [];
  List<Map<String, dynamic>> gastos = [];
  List<Map<String, dynamic>> horasInvertidas = [];
  List<Map<String, dynamic>> facturacion = [];
  List<Map<String, dynamic>> servicios = [];
  List<Map<String, dynamic>> propuestas = [];
  List<Map<String, dynamic>> oportunidades = [];

  Cliente? pickedCliente;

  Future<void> enviarProyecto(context) async {
    final Map<String, dynamic> data = {
      "cliente_id": pickedCliente!.clienteId,
      "proyecto": {
        "nombre": _nombreProyectoController.text,
        "alcance": _alcanceController.text,
        "entregables": _entregablesController.text,
        "cronograma": _cronogramaController.text,
        "fecha_inicio": _fechaInicioController.text,
        "fecha_fin": _fechaFinController.text,
        "costo_proyecto": _costoController.text.trim(),
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

    Map<String, dynamic> res = await Provider.of<ProviderProyecto>(
      context,
      listen: false,
    ).addNewProyecto(data);

    // final response
    if (res['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Respuesta: ${res['message']}"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al enviar: ${res['message']}"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                  _entregablesController.text.isEmpty ||
                  _cronogramaController.text.isEmpty ||
                  _fechaInicioController.text.isEmpty ||
                  _fechaFinController.text.isEmpty ||
                  pickedCliente == null ||
                  _costoController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Completa todos los campos del proyecto"),
                    duration: Durations.short3,
                  ),
                );
                return;
              }
              break;
            // case 1:
            //   if (equipo.isEmpty) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text("Agrega al menos un miembro al equipo"),
            //         duration: Durations.short3,
            //       ),
            //     );
            //     return;
            //   }
            //   break;
            // case 2:
            //   if (cotizaciones.isEmpty) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text("Agrega al menos una cotización"),
            //         duration: Durations.short3,
            //       ),
            //     );
            //     return;
            //   }
            //   break;
            // case 3:
            //   if (gastos.isEmpty) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text("Agrega al menos un gasto"),
            //         duration: Durations.short3,
            //       ),
            //     );
            //     return;
            //   }
            //   break;

            // case 4:
            //   if (propuestas.isEmpty) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text("Agrega al menos una propuesta"),
            //         duration: Durations.short3,
            //       ),
            //     );
            //     return;
            //   }
            //   break;

            // case 5:
            //   if (oportunidades.isEmpty) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text("Agrega al menos una oportunidad"),
            //         duration: Durations.short3,
            //       ),
            //     );
            //     return;
            //   }
            //   break;
          }

          if (_currentStep < 6) {
            setState(() => _currentStep += 1);
          } else {
            enviarProyecto(context);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: double.infinity),
                textFieldWidgetUI(
                  width: 250,
                  label: "Cliente",
                  controller: contClient,
                  onTap: () async {
                    Cliente? valueClient = await showDialog(
                      context: context,
                      builder: (context) {
                        return WindowsSelectorDialog<Cliente>(
                          items: listClientsFilter,
                          labelBuilder: (value) => limitarTexto(
                            '${value.nombre} - tel : ${value.telefono}',
                            50,
                          ),
                          title: 'Buscar Clientes',
                        );
                      },
                    );
                    if (valueClient != null) {
                      setState(() => pickedCliente = valueClient);
                      contClient.text = pickedCliente!.nombre!.toUpperCase();
                    }
                  },
                  readOnly: true,
                  // suffixIcon: pickedCliente != null ? Icons.close : null,
                  // onSuffixTap: pickedCliente != null ? cleanFormulario : null,
                ),
                textFieldWidgetUI(
                  controller: _nombreProyectoController,
                  label: 'Nombre del proyecto',
                ),
                textFieldWidgetUI(
                  controller: _alcanceController,
                  label: "Alcance",
                ),
                textFieldWidgetUI(
                  controller: _entregablesController,
                  label: "Entregables",
                ),
                textFieldWidgetUI(
                  controller: _cronogramaController,
                  label: "Cronograma",
                ),
                textFieldWidgetUI(
                  controller: _costoController,
                  label: "Costo",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  suffixIcon: Icons.monetization_on_outlined,
                ),
                SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 10,
                    children: [
                      Text('Fecha Inicio : ${_fechaInicioController.text}'),
                      IconButton(
                        onPressed: () async {
                          await pickSingleDate(context, (fecha) {
                            setState(() {
                              _fechaInicioController.text = fecha
                                  .toString()
                                  .substring(0, 10);
                            });
                          });
                        },
                        icon: Icon(Icons.calendar_month_outlined),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 10,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await pickSingleDate(context, (fecha) {
                            setState(() {
                              _fechaFinController.text = fecha
                                  .toString()
                                  .substring(0, 10);
                            });
                          });
                        },
                        icon: Icon(Icons.calendar_month),
                      ),
                      Text('Fecha Fin : ${_fechaFinController.text}'),
                    ],
                  ),
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
            content: CustomLoginButton(
              onPressed: () => enviarProyecto(context),

              text: "Registrar",
            ),
          ),
        ],
      ),
    );
  }
}
