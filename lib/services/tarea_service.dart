import 'dart:convert';
import 'package:http/http.dart' as http;
import '../interfaces/tarea.dart';

class TareaService {
  final String baseUrl = 'http://192.168.100.38:9085/api/Tareas/todas';
  final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJhZG1pbiIsIm5iZiI6MTc1MDM0NjcyNCwiZXhwIjoxNzgxNDUwNzI0LCJpYXQiOjE3NTAzNDY3MjR9.NChZbZBfi3IZIVidfWujhmcwgtFYF4hDM1Xg7Z7z5J0";
  final String user = "desa026";

  Future<List<Tarea>> fetchTareas({required int rangoIni, required int rangoFin}) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "bearer $token",
        "user": user,
        "rangoIni": rangoIni.toString(),
        "rangoFin": rangoFin.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List tareasData = jsonData["data"];
      return tareasData.map((e) => Tarea.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar tareas: ${response.statusCode}");
    }
  }
}
