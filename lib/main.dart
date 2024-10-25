// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Servicios/SignalRService.dart';
import 'package:flutter_application_1/Vista/TaskChartScreen.dart';
import 'package:flutter_application_1/Vista/agregar_tarea.dart';
import 'Modelo/Tareas.dart';
import 'Servicios/api_service.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TareaListScreen(),
    );
  }
}

class TareaListScreen extends StatefulWidget {
  @override
  _TareaListScreenState createState() => _TareaListScreenState();
}

class _TareaListScreenState extends State<TareaListScreen> {
  late Future<List<Tareas>> futureTareas;
  List<Tareas> tareas = [];

  @override
  void initState() {
    super.initState();
    futureTareas = ApiService().fetchTareas();
    signalRService.startConnection();
  }

  @override
  void dispose() {
    signalRService.stopConnection();
    // TODO: implement dispose
    super.dispose();
  }

  void _addTarea(Tareas tarea) {
    setState(() {
      tareas.add(tarea);
    });

    futureTareas = ApiService().fetchTareas();
     setState(() {});
  }

  // Función para eliminar tarea
  void _deleteTarea(int tareaId) async {
    try {
      await ApiService().deleteTarea(tareaId);
      setState(() {
        tareas.removeWhere((tarea) => tarea.id == tareaId); // Elimina localmente
      });

      futureTareas = ApiService().fetchTareas();
      setState(() {}); // Actualiza la UI

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarea eliminada con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la tarea')),
      );
    }
  }

  final SignalRService signalRService = SignalRService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUserScreen(onUserAdded: _addTarea),
                ),
              );
            },
          ),
        ],
      ),

      body: FutureBuilder<List<Tareas>>(
        future: futureTareas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Tareas tarea = snapshot.data![index];
                return ListTile(
                  title: Text(tarea.nombre),
                  subtitle: Text(tarea.description),
                  
                  leading: Checkbox(
                      value: tarea.isCompletada,
                      onChanged: (bool? value)
                      
                      async {
                        Tareas updatedTarea = tarea.copyWith(isCompletada: !tarea.isCompletada);
                        
                        try {
                          // Llama a la API para actualizar la tarea completa
                          await ApiService().updateTarea(updatedTarea);

                          futureTareas = ApiService().fetchTareas();

                          // Reemplazar la tarea en la lista si la API actualizó con éxito
                          setState(() {
                           // tareas[index] = updatedTarea;  // Actualiza la tarea en la lista local
                          });
                          
                          
                        } catch (e) { print(e); }
                        
                      }
                      ,
                    ),

                  trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey),
                  onPressed: () {
                    _deleteTarea(tarea.id); // Llama a la función de eliminación
                  },
                ),

                );
              },
            );


          } else {
            return Center(child: Text('No hay Tareas disponibles'));
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla del gráfico
          Navigator.push(
            context,
            MaterialPageRoute(

              builder: (context) => TaskChartScreen(
                eliminadas: signalRService.eliminadas.value,
                completadasNoEliminadas: signalRService.completadasNoEliminadas.value,
                pendientesNoEliminadas: signalRService.pendientesNoEliminadas.value,
                //eliminadas: 21,
                //completadasNoEliminadas: 26,
               //pendientesNoEliminadas: 54,
                 
            ),
          )
          );
        },
        child: Icon(Icons.pie_chart),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Ubicación del botón flotante
  

    );
  }
}
