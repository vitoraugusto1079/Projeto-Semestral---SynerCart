import 'dart:io';
import 'dart:typed_data';

Future<String> savePdfBytes(Uint8List bytes, String fileName) async {
  try {
    String? targetDir;
    if (Platform.isWindows) {
      final userProfile = Platform.environment['USERPROFILE'];
      if (userProfile != null) {
        final downloadsDir = Directory('$userProfile\\Downloads');
        if (await downloadsDir.exists()) {
          targetDir = downloadsDir.path;
        }
      }
    } else if (Platform.isMacOS || Platform.isLinux) {
      final home = Platform.environment['HOME'];
      if (home != null) {
        final downloadsDir = Directory('$home/Downloads');
        if (await downloadsDir.exists()) {
          targetDir = downloadsDir.path;
        }
      }
    }

    targetDir ??= Directory.systemTemp.path;
    final separator = Platform.isWindows ? '\\' : '/';
    final fullPath = '$targetDir$separator$fileName';
    final file = File(fullPath);
    await file.writeAsBytes(bytes, flush: true);

    if (Platform.isWindows) {
      // Abre o PDF automaticamente no leitor padrão do Windows
      try {
        await Process.run('cmd', ['/c', 'start', '', fullPath]);
      } catch (_) {}
    }

    return fullPath;
  } catch (_) {
    return fileName;
  }
}
