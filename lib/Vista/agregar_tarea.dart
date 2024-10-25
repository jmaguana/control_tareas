// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../Modelo/Tareas.dart';
import '../Servicios/api_service.dart'; // Importa el servicio API

class AddUserScreen extends StatefulWidget {
  final Function(Tareas) onUserAdded;

  AddUserScreen({required this.onUserAdded});

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      Tareas newTarea = Tareas(
        id: DateTime.now().millisecondsSinceEpoch, 
        nombre: _nombreController.text,
        description: _emailController.text,
        isDeleted: false,
        isCompletada: false,
      );

      try {
        await ApiService().addUser(newTarea); // Llama al método para agregar el usuario
        widget.onUserAdded(newTarea); // Agrega el nuevo usuario a la lista
        Navigator.pop(context); // Regresa a la pantalla anterior
      } catch (e) {
        // Manejar error de la API
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('No se pudo agregar una tarea: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Descripcion'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit, // Cambia aquí a _submit
                child: Text('Agregar Tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
