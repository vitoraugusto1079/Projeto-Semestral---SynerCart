import 'dart:typed_data';

class PickedFloorPlanImage {
  final String name;
  final Uint8List? bytes;

  const PickedFloorPlanImage({required this.name, this.bytes});
}

Future<PickedFloorPlanImage?> pickFloorPlanImage() async {
  return const PickedFloorPlanImage(name: 'planta_estacao_nova.png');
}
