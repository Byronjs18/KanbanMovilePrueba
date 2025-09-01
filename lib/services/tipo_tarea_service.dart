import 'dart:convert';
import 'package:http/http.dart' as http;
import '../interfaces/tipo_tarea.dart';

class TipoTareaService {
  final String baseUrl = 'http://192.168.0.7:9085/api/Tareas/tipos/sa';

  Future<List<TipoTarea>> getTiposTarea() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer '+ "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJhZG1pbiIsIm5iZiI6MTc1MDM0NjcyNCwiZXhwIjoxNzgxNDUwNzI0LCJpYXQiOjE3NTAzNDY3MjR9.NChZbZBfi3IZIVidfWujhmcwgtFYF4hDM1Xg7Z7z5J0", // mismo header que usas para estados
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> lista = data['data'];

      return lista.map((json) => TipoTarea.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar tipos de tarea: ${response.statusCode}');
    }
  }
}
