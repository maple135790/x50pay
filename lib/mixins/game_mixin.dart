mixin GameMixin {
  String getGameCabImage(String gameId) {
    return 'https://pay.x50.fun/static/gamesimg/$gameId.png?v1.1';
  }

  String getMachineIcon(String machineId) {
    switch (machineId) {
      case 'mmdx':
      case '2mmdx':
        return 'https://pay.x50.fun/static/machineicon/mmdx.png';
      default:
        return 'https://pay.x50.fun/static/machineicon/$machineId.png';
    }
  }
}

enum StoreMachine {
  chu('chu'),
  ddr('ddr'),
  gc('gc'),
  ju('ju'),
  mmdx('mmdx'),
  nvsv('nvsv'),
  pop('pop'),
  sdvx('sdvx'),
  tko('tko'),
  wac('wac'),
  twoChu('2chu'),
  twoMmdx('2mmdx'),
  twoTko('2tko'),
  twoDm('2dm'),
  twoNos('2nos'),
  twoBom('2bom'),
  x40chu('x40chu'),
  x40ddr('x40ddr'),
  x40maidx('x40maidx'),
  x40sdvx('x40sdvx'),
  x40tko('x40tko'),
  x40wac('x40wac');

  final String gameId;
  const StoreMachine(this.gameId);
}
