import 'dart:typed_data';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

Future<String> savePdfBytes(Uint8List bytes, String fileName) async {
  final blobParts = <JSAny>[bytes.toJS].toJS;
  final blob = web.Blob(blobParts, web.BlobPropertyBag(type: 'application/pdf'));
  final url = web.URL.createObjectURL(blob);

  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = url;
  anchor.download = fileName;
  anchor.style.display = 'none';
  web.document.body?.appendChild(anchor);
  anchor.click();
  anchor.remove();

  Future.delayed(const Duration(seconds: 2), () {
    web.URL.revokeObjectURL(url);
  });

  return 'Pasta de Downloads ($fileName)';
}
