import 'package:flutter/material.dart';
import 'package:flutter_application_1/Servicios/SignalRService.dart';

void main() async {
  final signalRService = SignalRService();
  await signalRService.startConnection();
  runApp(MyApp(signalRService: signalRService));
}

class MyApp extends StatelessWidget {
  final SignalRService signalRService;

  const MyApp({Key? key, required this.signalRService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Tareas SignalR")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<int>(
                valueListenable: signalRService.eliminadas,
                builder: (context, value, child) {
                  return Text("Tareas eliminadas: $value");
                },
              ),
              ValueListenableBuilder<int>(
                valueListenable: signalRService.completadasNoEliminadas,
                builder: (context, value, child) {
                  return Text("Tareas completadas no eliminadas: $value");
                },
              ),
              ValueListenableBuilder<int>(
                valueListenable: signalRService.pendientesNoEliminadas,
                builder: (context, value, child) {
                  return Text("Tareas pendientes no eliminadas: $value");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
