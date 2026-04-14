import 'claseempleado.dart';
import 'diccionarioempleado.dart';

class GuardaDatosDiccionario {
  // Agente para guardar datos del formulario al diccionario
  static void guardarEmpleadoEnDiccionario({
    required String nombre,
    required String puesto,
    required double salario,
  }) {
    // Usar el auto numérico para el ID
    int id = currentAutoId;
    
    // Crear el empleado con sus 4 atributos
    Empleado nuevoEmpleado = Empleado(
      id: id,
      nombre: nombre,
      puesto: puesto,
      salario: salario,
    );
    
    // Guardar en el diccionario
    datosEmpleado[id] = nuevoEmpleado;
    
    // Incrementar el auto numérico
    currentAutoId++;
  }
}
