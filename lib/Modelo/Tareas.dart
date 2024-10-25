class Tareas {
  final int id;
  final String nombre;
  final String description;
  final bool isCompletada;
  final bool isDeleted;

  Tareas({required this.id, required this.nombre, required this.description, required this.isCompletada, required this.isDeleted});

  factory Tareas.fromJson(Map<String, dynamic> json) {
    return Tareas(
      id: json['id'],
      nombre: json['nombre'],
      description: json['descripcion'],
      isCompletada: json['completada'],
      isDeleted: json['isDeleted'],
    );
  }

 Tareas copyWith({
    int? id,
    String? nombre,
    String? description,
    bool? isCompletada,
    bool? isDeleted,
  }) {
    return Tareas(
      id: id ?? this.id,  // Si id es nulo, usar el id actual
      nombre: nombre ?? this.nombre,  // Si nombre es nulo, usar el nombre actual
      description: description ?? this.description,  // Si description es nulo, usar la descripción actual
      isCompletada: isCompletada ?? this.isCompletada,  // Si isCompletada es nulo, usar el estado actual
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
