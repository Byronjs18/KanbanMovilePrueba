import 'dart:convert';
import 'package:http/http.dart' as http;
import '../interfaces/tarea.dart';

class TareasCreadasService {
  final String baseUrl = "http://192.168.100.38:9085/api/Tareas/creadas";
  

  Future<List<Tarea>> fetchTareasCreadas({
    required String token,
    required String user,
    int rangoIni = 0,
    int rangoFin = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl?rangoIni=$rangoIni&rangoFin=$rangoFin"),
        headers: {
          "Authorization": token,
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
        throw Exception("Error al cargar tareas creadas: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error en fetchTareasCreadas: $e");
    }
  }
}
