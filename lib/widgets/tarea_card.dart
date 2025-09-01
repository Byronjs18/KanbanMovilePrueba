import 'package:flutter/material.dart';

// 🔹 Convierte código hex (#RRGGBB) a Color
Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class TareaCard extends StatelessWidget {
  final String id;
  final String descripcion;
  final String prioridad; // Ej: "CRITICO", "ALTO", "BAJO", "NORMAL"
  final String backColor; // Fondo que viene del modelo de tarea
  final String descripcionTipoTarea;
  final String descripcionReferencia;
  final int referencia;
  final DateTime fechaInicial;
  final DateTime fechaFinal;

  const TareaCard({
    Key? key,
    required this.id,
    required this.descripcion,
    required this.prioridad,
    required this.backColor,
    required this.descripcionTipoTarea,
    required this.descripcionReferencia,
    required this.referencia,
    required this.fechaInicial,
    required this.fechaFinal,
  }) : super(key: key);

  // 🔹 Colores de la franja según prioridad
  Color _getFranjaColor(String prioridad) {
    switch (prioridad.toUpperCase()) {
      case "CRITICO":
        return hexToColor("#FA5858"); // rojo
      case "ALTO":
        return hexToColor("#5858FA"); // azul
      case "NORMAL":
        return hexToColor("#F4FA58"); // amarillo
      case "BAJO":
        return hexToColor("#2EFE2E"); // verde
      default:
        return Colors.grey; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    Color fondoTarjeta = hexToColor(backColor);
    Color franjaColor = _getFranjaColor(prioridad);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: fondoTarjeta, // 🔹 ahora el fondo depende de la tarea
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Franja que se ajusta al alto del contenido
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: franjaColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "ID: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: id,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Descripción: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: descripcion,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Fecha Inicial: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: fechaInicial.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Fecha Final: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: fechaFinal.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Referencia: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "$descripcionReferencia ($referencia)",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
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
