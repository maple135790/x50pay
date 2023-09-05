class ScanPayData {
  final String rawGameCabImageUrl;
  final int cabNum;
  final List<List<dynamic>> mode;
  final String cabLabel;

  const ScanPayData({
    required this.rawGameCabImageUrl,
    required this.cabNum,
    required this.mode,
    required this.cabLabel,
  });
  String get gameCabImageUrl => 'https://pay.x50.fun$rawGameCabImageUrl';

  const ScanPayData.empty()
      : rawGameCabImageUrl = '',
        cabNum = 0,
        mode = const [],
        cabLabel = '';
}
