import 'package:flutter/material.dart';

class CreateReportScreen extends StatelessWidget {
  const CreateReportScreen({super.key});

  static const routeName = '/create_report';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo reporte')),
      body: const Center(
        child: Text(
          'Pantalla de creación de reporte.',
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
