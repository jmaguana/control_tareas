import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  late final HubConnection _hubConnection;

  // ValueNotifiers para cada valor individual
  final ValueNotifier<int> eliminadas = ValueNotifier<int>(0);
  final ValueNotifier<int> completadasNoEliminadas = ValueNotifier<int>(0);
  final ValueNotifier<int> pendientesNoEliminadas = ValueNotifier<int>(0);

  SignalRService() {
    // Configurar la URL del servidor de SignalR
    _hubConnection = HubConnectionBuilder()
      .withUrl("https://192.168.3.118:5001/tareasHub") // Asegúrate de usar la URL correcta
      .build();

    // Registrar el manejador de mensajes
    _hubConnection.on("ReceiveMessage", _handleReceiveMessage);
  }
  
  // Método para iniciar la conexión
  Future<void> startConnection() async {
     try {
      await _hubConnection.start();
      print("Conexión establecida con el servidor SignalR.");
      } catch (e) {
      print("Error al conectar con SignalR: $e");
    }
  }

  // Este método maneja los mensajes recibidos desde el servidor
  void _handleReceiveMessage(List<Object?>? args) {
  if (args != null && args.isNotEmpty) {
    // Asegurarse de que el primer argumento es un Map<String, dynamic>
    final mensaje = args[0] as Map<String, dynamic>;

    // Actualiza los ValueNotifiers con los valores recibidos
     eliminadas.value = mensaje["Eliminadas"] is int ? mensaje["Eliminadas"] as int : eliminadas.value;
      completadasNoEliminadas.value = mensaje["CompletadasNoEliminadas"] is int ? mensaje["CompletadasNoEliminadas"] as int : completadasNoEliminadas.value;
      pendientesNoEliminadas.value = mensaje["PendientesNoEliminadas"] is int ? mensaje["PendientesNoEliminadas"] as int : pendientesNoEliminadas.value;
   }
}

  // Método para detener la conexión
  Future<void> stopConnection() async {
    await _hubConnection.stop();
    print("Conexión con SignalR detenida.");
  }
}
