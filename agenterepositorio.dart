import 'dart:io';

/// Agente Interactivo para Subir Proyectos a GitHub
/// 
/// Puedes ejecutar este archivo abriendo la terminal en la raíz de tu proyecto
/// y ejecutando: dart agenterepositorio.dart

void main() async {
  print('\n' + '=' * 50);
  print('🚀 AGENTE DE REPOSITORIO GITHUB 🚀');
  print('=' * 50);
  print('Este script interactivo automatiza la subida de tu proyecto a GitHub.\n');

  // 1. Inicializar git
  print('Verificando repositorio local...');
  await runCommand('git', ['init']);

  // 2. Solicitar URL del repositorio
  String repoUrl = promptUser('Ingresa el enlace del repositorio de GitHub\n(Ej: https://github.com/usuario/repo.git)');
  
  if (repoUrl.isNotEmpty) {
     // Verificar si remote origin ya existe
     var remoteCheck = await Process.run('git', ['remote'], runInShell: true);
     if (remoteCheck.stdout.toString().contains('origin')) {
        await runCommand('git', ['remote', 'set-url', 'origin', repoUrl]);
     } else {
        await runCommand('git', ['remote', 'add', 'origin', repoUrl]);
     }
  } else {
     print('\n⚠️ No ingresaste URL. Se intentará usar la configuración actual si ya existe.');
  }

  // 3. git add .
  print('\nPreparando archivos (git add .)...');
  await runCommand('git', ['add', '.']);
  
  // Mostrar resumen de cambios rápido
  await runCommand('git', ['status', '--short']);

  // 4. Solicitar el mensaje del commit
  String commitMsg = promptUser('Ingresa el mensaje para este commit', defaultValue: 'Subiendo cambios iniciales');
  
  // Realizar el commit
  var commitResult = await Process.run('git', ['commit', '-m', commitMsg], runInShell: true);
  if (commitResult.exitCode == 0) {
    print(commitResult.stdout.toString().trim());
  } else if (commitResult.stdout.toString().contains('nothing to commit')) {
    print('\n⚠️ No hay cambios nuevos para realizar commit.');
  } else {
    print(commitResult.stdout.toString().trim());
    print(commitResult.stderr.toString().trim());
  }

  // 5. Especificar la rama
  String branch = promptUser('Ingresa el nombre de la rama principal', defaultValue: 'main');
  
  // Renombrar la rama actual a la solicitada (usualmente master a main)
  await runCommand('git', ['branch', '-M', branch]);

  // 6. Hacer Push
  print('\nSubiendo el código a GitHub en la rama "$branch"... esto puede tomar unos segundos ⏳');
  bool pushSuccess = await runCommand('git', ['push', '-u', 'origin', branch]);

  if (pushSuccess) {
    print('\n' + '=' * 50);
    print('✅ ¡Éxito! Tu proyecto fue subido a GitHub correctamente.');
    print('🔗 Rama utilizada: $branch');
    print('=' * 50 + '\n');
  } else {
    print('\n' + '=' * 50);
    print('❌ Ocurrió un error al intentar subir tu código (git push).');
    print('Asegúrate de que estás autenticado en GitHub o que el link sea correcto.');
    print('=' * 50 + '\n');
  }
}

/// Función auxiliar para ejecutar comandos en la terminal
Future<bool> runCommand(String executable, List<String> arguments) async {
  // En Windows es recomendable usar runInShell: true para comandos como git
  var result = await Process.run(executable, arguments, runInShell: true);
  
  // Imprimir errores fuertes (excluyendo advertencias menores)
  if (result.exitCode != 0 && result.stderr.toString().trim().isNotEmpty) {
    print('=> Output: ${result.stderr.toString().trim()}');
  }
  
  return result.exitCode == 0;
}

/// Función auxiliar interactiva que muestra el prompt en la consola y espera un String.
String promptUser(String message, {String? defaultValue}) {
  print('\n> $message');
  if (defaultValue != null) {
    stdout.write('  [Enter para "$defaultValue"]: ');
  } else {
    stdout.write('  : ');
  }
  
  String? input = stdin.readLineSync();
  
  // Si el usuario da "Enter" vacío
  if (input == null || input.trim().isEmpty) {
    return defaultValue ?? '';
  }
  
  return input.trim();
}
