import 'dart:convert';
import 'package:http/http.dart' as http;
import '../interfaces/tarea.dart';

class TareasAsignadasService {
  final String baseUrl = "http://192.168.100.38:9085/api/Tareas/asignadas";
  final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJhZG1pbiIsIm5iZiI6MTc1MDM0NjcyNCwiZXhwIjoxNzgxNDUwNzI0LCJpYXQiOjE3NTAzNDY3MjR9.NChZbZBfi3IZIVidfWujhmcwgtFYF4hDM1Xg7Z7z5J0";
  final String user = "desa026";

  Future<List<Tarea>> fetchTareasAsignadas({
    int rangoIni = 0,
    int rangoFin = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl?rangoIni=$rangoIni&rangoFin=$rangoFin"),
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "rangoIni": rangoIni.toString(),
          "rangoFin": rangoFin.toString(),
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List tareasJson = jsonData["data"];
        return tareasJson.map((e) => Tarea.fromJson(e)).toList();
      } else {
        throw Exception("Error al cargar tareas asignadas: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error en fetchTareasAsignadas: $e");
    }
  }
}
