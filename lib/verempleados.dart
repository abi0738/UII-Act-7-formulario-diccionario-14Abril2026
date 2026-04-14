import 'package:flutter/material.dart';
import 'diccionarioempleado.dart';
import 'claseempleado.dart';

class VerEmpleadosScreen extends StatefulWidget {
  const VerEmpleadosScreen({super.key});

  @override
  State<VerEmpleadosScreen> createState() => _VerEmpleadosScreenState();
}

class _VerEmpleadosScreenState extends State<VerEmpleadosScreen> {
  @override
  Widget build(BuildContext context) {
    // Al cargar la vista de nuevo, leemos el diccionario actualizado
    // Usamos values.toList() para convertir el Map a una Lista que ListView pueda entender.
    List<Empleado> listaEmpleados = datosEmpleado.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantilla de Empleados', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: listaEmpleados.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.folder_open, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay empleados registrados.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: listaEmpleados.length,
              itemBuilder: (context, index) {
                final empleado = listaEmpleados[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade50,
                      radius: 28,
                      child: Text(
                        '#${empleado.id}',
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    title: Text(
                      empleado.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.work, size: 18, color: Colors.black54),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                empleado.puesto,
                                style: const TextStyle(fontSize: 15, color: Colors.black54),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.monetization_on, size: 18, color: Colors.green),
                            const SizedBox(width: 6),
                            Text(
                              '\$${empleado.salario.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16, 
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
