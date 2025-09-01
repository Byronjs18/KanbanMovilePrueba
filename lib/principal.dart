import 'package:appkanban/interfaces/prioridad.dart';
import 'package:appkanban/interfaces/tarea.dart';
import 'package:appkanban/interfaces/tipo_tarea.dart';
import 'package:appkanban/services/prioridad_service.dart';
import 'package:appkanban/services/tarea_invitada_service.dart';
import 'package:appkanban/services/tarea_service.dart';
import 'package:appkanban/services/tareas_asignadas_service.dart';
import 'package:appkanban/services/tareas_creadas_service.dart';
import 'package:appkanban/services/tipo_tarea_service.dart';
import 'package:flutter/material.dart';
import '../interfaces/estado.dart';
import '../services/estado_service.dart';
import 'package:appkanban/widgets/kanban_pageview.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({Key? key}) : super(key: key);

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  List<TipoTarea> tiposTarea = [];
  List<Estado> estados = [];
  List<Prioridad> prioridades = [];
  List<Tarea> tareas = [];
  List<Tarea> tareasCreadas = [];
  List<Tarea> tareasAsignadas = [];
  List<Tarea> tareasInvitadas = [];
  List<Tarea> tareasFiltradasPorEstado = [];
  String _pestanaSeleccionada = "todas"; // todas | creadas

  TipoTarea? _tipoFiltroSeleccionado;
  Prioridad? _prioridadFiltroSeleccionada;
  String? tipoSeleccionado;
  Estado? _estadoFiltroSeleccionado;
  Prioridad? prioridadSeleccionada;
  // 🔹 Filtro por estado (ya lo tienes)

// 🔹 Filtro por tipo de tarea

// 🔹 Filtro por prioridad

  bool _cargando = false;
  bool _mostrarFiltros = false;
  bool cargandoInvitadas = false;

  @override
  void initState() {
    super.initState();
    _cargarEstados();
    _cargarTiposTarea();
    _cargarPrioridades();
    _cargarTareas();
    _cargarTareasAsignadas();
  }

  void _cargarEstados() async {
    try {
      final data = await EstadoService().getEstados();
      setState(() => estados = data);
    } catch (e) {
      print("Error cargando estados: $e");
    }
  }

  void _cargarTiposTarea() async {
    try {
      final data = await TipoTareaService().getTiposTarea();
      setState(() => tiposTarea = data);
    } catch (e) {
      print("Error cargando tipos de tarea: $e");
    }
  }

  void _cargarPrioridades() async {
    try {
      final data = await PrioridadService().fetchPrioridades();
      setState(() => prioridades = data);
    } catch (e) {
      print("Error cargando prioridades: $e");
    }
  }

  void _cargarTareas() async {
    setState(() => _cargando = true);
    try {
      final data = await TareaService().fetchTareas(
        rangoIni: 0,
        rangoFin: 30,
      );
      setState(() => tareas = data);
    } catch (e) {
      print("Error cargando tareas: $e");
    } finally {
      setState(() => _cargando = false);
    }
  }

  void _cargarTareasCreadas() async {
    setState(() => _cargando = true);
    try {
      final data = await TareasCreadasService().fetchTareasCreadas(
        token:
            "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJhZG1pbiIsIm5iZiI6MTc1MDM0NjcyNCwiZXhwIjoxNzgxNDUwNzI0LCJpYXQiOjE3NTAzNDY3MjR9.NChZbZBfi3IZIVidfWujhmcwgtFYF4hDM1Xg7Z7z5J0",
        user: "desa026",
      );
      setState(() => tareasCreadas = data);
    } catch (e) {
      print("Error cargando tareas creadas: $e");
    } finally {
      setState(() => _cargando = false);
    }
  }

  void _cargarTareasAsignadas() async {
    setState(() => _cargando = true);
    try {
      final data = await TareasAsignadasService().fetchTareasAsignadas(
        rangoIni: 0,
        rangoFin: 10,
      );
      setState(() => tareasAsignadas = data);
    } catch (e) {
      print("Error cargando tareas asignadas: $e");
    } finally {
      setState(() => _cargando = false);
    }
  }

  void _cargarTareasInvitadas() async {
    setState(() => cargandoInvitadas = true);
    try {
      final data = await TareasInvitadasService().fetchTareasInvitadas(
        rangoIni: 0,
        rangoFin: 10,
      );
      setState(() {
        tareasInvitadas = data;
      });
    } catch (e) {
      print("Error cargando tareas invitadas: $e");
      setState(() {
        tareasInvitadas = [];
      });
    } finally {
      setState(() => cargandoInvitadas = false);
    }
  }

  void _filtrarTareas() {
    List<Tarea> origen;

    if (_pestanaSeleccionada == "creadas") {
      origen = tareasCreadas;
    } else if (_pestanaSeleccionada == "asignadas") {
      origen = tareasAsignadas;
    } else if (_pestanaSeleccionada == "invitadas") {
      origen = tareasInvitadas;
    } else {
      origen = tareas;
    }

    List<Tarea> filtradas = origen;

    // 🔹 Filtro por estado
    if (_estadoFiltroSeleccionado != null) {
      filtradas = filtradas
          .where((t) => t.tareaEstado == _estadoFiltroSeleccionado!.descripcion)
          .toList();
    }

    // 🔹 Filtro por tipo de tarea
    if (_tipoFiltroSeleccionado != null &&
        _tipoFiltroSeleccionado!.descripcion.isNotEmpty) {
      filtradas = filtradas
          .where((t) =>
              t.descripcionTipoTarea == _tipoFiltroSeleccionado!.descripcion)
          .toList();
    }

    // 🔹 Filtro por prioridad
    if (_prioridadFiltroSeleccionada != null) {
      filtradas = filtradas
          .where((t) =>
              t.nomNivelPrioridad == _prioridadFiltroSeleccionada!.nombre)
          .toList();
    }

    setState(() {
      tareasFiltradasPorEstado = filtradas;
    });
  }

  void _limpiarFiltros() {
    setState(() {
      _estadoFiltroSeleccionado = null;
      _tipoFiltroSeleccionado = null;
      _prioridadFiltroSeleccionada = null;
      tareasFiltradasPorEstado = []; // 🔹 muestra todas
    });
  }
  // 🔹 Agrupar tareas y mostrarlas en PageView por estado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEF5E7),
      appBar: AppBar(
        backgroundColor: const Color(0xff134895),
        title: const Center(
          child: Text(
            "Tablero Kanban DMOSOFT",
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botón Filtros
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFEF5E7),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _mostrarFiltros = !_mostrarFiltros;
                    if (_mostrarFiltros && estados.isEmpty) {
                      _cargarEstados();
                    }
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filtros',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.expand_more)
                    ],
                  ),
                ),
              ),
            ),

            // Contenedor de filtros
            if (_mostrarFiltros)
              Column(
                children: [
                  const SizedBox(height: 10),
                  // Estados y tipos
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Estado>(
                              hint: const Text("Estado"),
                              isExpanded: true,
                              value: _estadoFiltroSeleccionado,
                              items: estados
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.descripcion),
                                      ))
                                  .toList(),
                              onChanged: (nuevo) {
                                setState(
                                    () => _estadoFiltroSeleccionado = nuevo);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 50,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<TipoTarea>(
                              hint: const Text("Tipo"),
                              value: _tipoFiltroSeleccionado,
                              isExpanded: true,
                              items: tiposTarea.map((tipo) {
                                return DropdownMenuItem(
                                  value: tipo,
                                  child: Text(
                                      tipo.descripcion), // usamos descripcion
                                );
                              }).toList(),
                              onChanged: (nuevo) {
                                setState(() => _tipoFiltroSeleccionado = nuevo);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Prioridades
                  prioridades.isNotEmpty
                      ? Row(
                          children: [
                            // 🔹 Dropdown de prioridades
                            Expanded(
                              child: Container(
                                height: 50,
                                padding:
                                    const EdgeInsets.only(right: 35),
                                
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<Prioridad>(
                                    hint:
                                        const Text("Prioridad"),
                                    value: _prioridadFiltroSeleccionada,
                                    isExpanded: true,
                                    items: prioridades.map((p) {
                                      return DropdownMenuItem(
                                        value: p,
                                        child: Text(p.nombre), // usamos nombre
                                      );
                                    }).toList(),
                                    onChanged: (nuevo) {
                                      setState(() =>
                                          _prioridadFiltroSeleccionada = nuevo);
                                    },
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            // 🔹 Botón de limpiar filtros
                            ElevatedButton.icon(
                              onPressed: _limpiarFiltros,
                              icon: const Icon(Icons.clear, color: Colors.white, size: 18),
                              label: const Text("Limpiar Filtros", style: TextStyle(color: Colors.white),),
                              
                              style: ElevatedButton.styleFrom(
                                
                                backgroundColor:  Color(0xff134895),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 12),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),

                  const SizedBox(height: 6),
                  _inputFiltro("Buscar por Referencia"),
                  const SizedBox(height: 6),
                  _inputFiltro("Buscar por Usuario"),
                ],
              ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 125,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _pestanaSeleccionada = "todas";
                        });
                        _cargarTareas();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pestanaSeleccionada == "todas"
                            ? Colors.grey
                            : Color(0xff134895),
                      ),
                      child: const Text(
                        "Todas",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 125,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _pestanaSeleccionada = "creadas";
                        });
                        _cargarTareasCreadas();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pestanaSeleccionada == "creadas"
                            ? Colors.grey
                            : Color(0xff134895),
                      ),
                      child: const Text("Creadas",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 125,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _pestanaSeleccionada = "asignadas";
                        });
                        _cargarTareasAsignadas();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pestanaSeleccionada == "asignadas"
                            ? Colors.grey
                            : Color(0xff134895),
                      ),
                      child: const Text("Asignadas",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 125,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _pestanaSeleccionada = "invitadas";
                        });
                        _cargarTareasInvitadas();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pestanaSeleccionada == "invitadas"
                            ? Colors.grey
                            : Color(0xff134895),
                      ),
                      child: const Text("Invitadas",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

// 🔹 Tablero deslizable por estados
            Expanded(
              child: Container(
                width: double.infinity,
                height: 300,
                color: const Color(0xffFEF5E7),
                child: _cargando
                    ? const Center(child: CircularProgressIndicator())
                    : Builder(
                        builder: (_) {
                          // 🔹 Elegir la lista según pestaña
                          List<Tarea> tareasBase;
                          switch (_pestanaSeleccionada) {
                            case "todas":
                              tareasBase = tareas;
                              break;
                            case "creadas":
                              tareasBase = tareasCreadas;
                              break;
                            case "asignadas":
                              tareasBase = tareasAsignadas;
                              break;
                            case "invitadas":
                              tareasBase = tareasInvitadas;
                              break;
                            default:
                              tareasBase = [];
                          }
                          if (_estadoFiltroSeleccionado != null) {
                            tareasBase = tareasBase
                                .where((t) =>
                                    t.estadoObjeto ==
                                        _estadoFiltroSeleccionado!.estado &&
                                    t.tareaEstado ==
                                        _estadoFiltroSeleccionado!.descripcion)
                                .toList();
                          }

// 🔹 Aplicar filtro de tipo de tarea
                          // Aplicar filtros
                          if (_estadoFiltroSeleccionado != null) {
                            tareasBase = tareasBase
                                .where((t) =>
                                    t.tareaEstado ==
                                    _estadoFiltroSeleccionado!.descripcion)
                                .toList();
                          }

                          if (_tipoFiltroSeleccionado != null) {
                            tareasBase = tareasBase
                                .where((t) =>
                                    t.descripcionTipoTarea ==
                                    _tipoFiltroSeleccionado!.descripcion)
                                .toList();
                          }

                          if (_prioridadFiltroSeleccionada != null) {
                            tareasBase = tareasBase.where((t) {
                              final tareaPrioridad =
                                  t.nomNivelPrioridad.toLowerCase().trim() ??
                                      '';
                              final filtroPrioridad =
                                  _prioridadFiltroSeleccionada!.nombre
                                      .toLowerCase()
                                      .trim();
                              return tareaPrioridad == filtroPrioridad;
                            }).toList();
                          }

                          return KanbanPageView(tareas: tareasBase);
                        },
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 🔹 Caja de filtro


// 🔹 Input de búsqueda
Widget _inputFiltro(String label) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xffCED4DA)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextField(
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        border: InputBorder.none,
      ),
    ),
  );
}
