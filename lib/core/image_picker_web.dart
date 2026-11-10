import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

class PickedFloorPlanImage {
  final String name;
  final Uint8List? bytes;

  const PickedFloorPlanImage({required this.name, this.bytes});
}

Future<PickedFloorPlanImage?> pickFloorPlanImage() async {
  final completer = Completer<PickedFloorPlanImage?>();
  final input = web.document.createElement('input') as web.HTMLInputElement;
  input.type = 'file';
  input.accept = 'image/*';
  input.style.display = 'none';
  web.document.body?.appendChild(input);

  input.onchange = ((web.Event _) {
    final files = input.files;
    if (files == null || files.length == 0) {
      input.remove();
      if (!completer.isCompleted) completer.complete(null);
      return;
    }
    final file = files.item(0)!;
    final reader = web.FileReader();
    reader.onload = ((web.Event _) {
      final result = reader.result;
      Uint8List? bytes;
      if (result != null) {
        final buffer = result as JSArrayBuffer;
        bytes = buffer.toDart.asUint8List();
      }
      input.remove();
      if (!completer.isCompleted) {
        completer.complete(PickedFloorPlanImage(name: file.name, bytes: bytes));
      }
    }).toJS;
    reader.readAsArrayBuffer(file);
  }).toJS;

  input.click();
  return completer.future;
}
