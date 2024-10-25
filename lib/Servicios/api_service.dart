// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Modelo/Tareas.dart';

class ApiService {
  static const String baseUrl = 'https://192.168.3.118:5001'; // URL de tu API

  Future<List<Tareas>> fetchTareas() async {
    final response = await http.get(Uri.parse('$baseUrl/api/tareas'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Tareas.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar tareas');
    }
  }

  Future<void> addUser(Tareas tarea) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/tareas'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nombre': tarea.nombre,
        'descripcion': tarea.description,
        'completada' : tarea.isCompletada,
        'isDeleted' : tarea.isDeleted,

      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al agregar Tarea');
    }
  }

   Future<void> deleteTarea(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/tareas/$id'));

    //if (response.statusCode != 200) {
     // throw Exception('Error al eliminar la tarea');
   // }
  }


   // Función para actualizar el estado de la tarea (completada o no)
  Future<void> updateTarea(Tareas tarea) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/tareas/${tarea.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'id': tarea.id,
        'nombre': tarea.nombre,
        'descripcion': tarea.description,
        'completada' : tarea.isCompletada,
        'isDeleted' : tarea.isDeleted,
      }),
    );

    //if (response.statusCode != 200) {
     // throw Exception('Error al actualizar la tarea');
   // }
  }

}
