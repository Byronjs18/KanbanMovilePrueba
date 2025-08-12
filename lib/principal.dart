import 'package:flutter/material.dart';

class PrincipalView extends StatelessWidget {
  const PrincipalView({Key? key}) : super(key: key);

  @override


  
  Widget build(BuildContext context) {
    final List<List<String>> todasLasTareas = [
      ["1", "REF-001", "Alta"],
      ["2", "REF-002", "Media"],
      ["3", "REF-003", "Baja"],
      ["4", "REF-004", "Alta"],
      ["5", "REF-005", "Alta"],
      ["6", "REF-006", "Media"],
      ["7", "REF-007", "Baja"],
      ["8", "REF-008", "Alta"],
      ["9", "REF-005", "Alta"],
      ["10", "REF-006", "Media"],
      ["11", "REF-007", "Baja"],
      ["12", "REF-008", "Alta"],
    ];

    // Dividimos las tareas en columnas (ej. 4 columnas de ejemplo)
    final List<List<List<String>>> columnas = [
      todasLasTareas.sublist(0, 8),
      todasLasTareas.sublist(0, 12),
      todasLasTareas.sublist(0, 5),
      todasLasTareas.sublist(0, 10),
    ];

    // Agrupamos las columnas de 2 en 2 para las páginas
    final List<List<List<List<String>>>> paginas = [];
    for (int i = 0; i < columnas.length; i += 2) {
      paginas.add(columnas.sublist(i, (i + 2).clamp(0, columnas.length)));
    }



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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              // Aquí va la acción al pulsar el menú
              print("Menú presionado");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xffFEF5E7),
            width: double.infinity,
            child: ExpansionTile(
              title: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Filtros",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(child: _filtroBox("Estados")),
                      const SizedBox(width: 8),
                      Expanded(child: _filtroBox("Tipos")),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: _filtroBox("Prioridad"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: _inputFiltro("Buscar por Referencia"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: _inputFiltro("Buscar por Usuario"),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _BotonAzul(pestanias: "Todas"),
                        SizedBox(width: 15),
                        _BotonAzul(pestanias: "Creadas"),
                        SizedBox(width: 15),
                        _BotonAzul(pestanias: "Asignadas"),
                        SizedBox(width: 15),
                        _BotonAzul(pestanias: "Invitadas"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 8),
              child: PageView(
                pageSnapping: true,
                scrollDirection: Axis.horizontal,
                children: paginas.expand((grupo) => grupo).map((columna) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: buildColumnaTareas(
                        columna, MediaQuery.of(context).size.width),
                  );
                }).toList(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5, right: 10),
                child: Container(
                  height: 20,
                  width: 20,
                  color: Color(0xff134895),
                  child: const Text(
                    "1",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, right: 10),
                child: Container(
                  child: Container(
                    height: 20,
                    width: 20,
                    color: Color(0xff134895),
                    child: const Text(
                      "2",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, right: 10),
                child: Container(
                  child: Container(
                    height: 20,
                    width: 20,
                    color: Color(0xff134895),
                    child: const Text(
                      "3",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, right: 10),
                child: Container(
                  child: Container(
                    height: 20,
                    width: 20,
                    color: Color(0xff134895),
                    child: const Text(
                      "4",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _BotonAzul extends StatelessWidget {
  const _BotonAzul({required this.pestanias});
  final String pestanias;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff134895),
          foregroundColor: Colors.white,
        ),
        child: Text(pestanias),
      ),
    );
  }
}

Widget _filtroBox(String label) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
      color: const Color(0xFFE0E0E0),
      border: Border.all(color: Color(0xffCED4DA)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(label),
        ),
        const Spacer(),
        const Icon(Icons.expand_more),
      ],
    ),
  );
}

Widget _inputFiltro(String label) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Color(0xffCED4DA)),
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

Widget tareaCard(String id, String referencia, String prioridad) {
  Color prioridadColor = prioridad == "Alta"
      ? Colors.red
      : prioridad == "Media"
          ? Colors.orange
          : Colors.green;

  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 3),
        )
      ],
    ),
    child: Row(
      children: [
        // Línea de color a la izquierda
        Container(
          width: 6, // ancho de la línea
          height:
              80, // altura aproximada de la tarjeta, o usa double.infinity y constraints
          decoration: BoxDecoration(
            color: prioridadColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
        ),

        // Espacio entre línea y contenido
        const SizedBox(width: 10),

        // Contenido de la tarjeta
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID: $id",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text("Referencia: $referencia"),
                const SizedBox(height: 5),
                Text(
                  "Prioridad: $prioridad",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildColumnaTareas(List<List<String>> tareas, double width) {
  return SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tareas.map((t) => tareaCard(t[0], t[1], t[2])).toList(),
    ),
  );
}
