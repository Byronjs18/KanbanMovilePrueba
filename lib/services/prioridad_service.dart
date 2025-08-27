import 'dart:convert';
import 'package:http/http.dart' as http;
import '../interfaces/prioridad.dart';

class PrioridadService {
  final String baseUrl = 'http://192.168.100.38:9085/api/Tareas/tipo/prioridad/sa';
  final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJhZG1pbiIsIm5iZiI6MTc1MDM0NjcyNCwiZXhwIjoxNzgxNDUwNzI0LCJpYXQiOjE3NTAzNDY3MjR9.NChZbZBfi3IZIVidfWujhmcwgtFYF4hDM1Xg7Z7z5J0";
  final String user = "desa026";

  Future<List<Prioridad>> fetchPrioridades() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": 'bearer ' + token,
        "user": user,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List prioridadesData = jsonData["data"];
      return prioridadesData.map((e) => Prioridad.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar prioridades: ${response.statusCode}");
    }
  }
}
