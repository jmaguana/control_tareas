import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TaskChartScreen extends StatelessWidget {
  final int eliminadas;
  final int completadasNoEliminadas;
  final int pendientesNoEliminadas;

  const TaskChartScreen({
    Key? key,
    required this.eliminadas,
    required this.completadasNoEliminadas,
    required this.pendientesNoEliminadas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gráfico de Tareas"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PieChart(
          PieChartData(
            sections: showingSections(),
            borderData: FlBorderData(show: false),
            centerSpaceRadius: 40,
            sectionsSpace: 2,
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        value: eliminadas.toDouble(),
        title: 'Eliminadas\n$eliminadas',
        color: Colors.red,
        radius: 50,
      ),
      PieChartSectionData(
        value: completadasNoEliminadas.toDouble(),
        title: 'Completadas\n$completadasNoEliminadas',
        color: Colors.green,
        radius: 50,
      ),
      PieChartSectionData(
        value: pendientesNoEliminadas.toDouble(),
        title: 'Pendientes\n$pendientesNoEliminadas',
        color: Colors.blue,
        radius: 50,
      ),
    ];
  }
}