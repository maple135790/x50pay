import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:x50pay/r.g.dart';

mixin GameMixin {
  ImageProvider getGameCabImageFallback(String gameId) {
    final machine = StoreMachine.values.firstWhereOrNull((m) => m.gameId == gameId);

    switch (machine) {
      case StoreMachine.chu:
        return R.image.chu();
      case StoreMachine.ddr:
        return R.image.ddr();
      case StoreMachine.gc:
        return R.image.gc();
      case StoreMachine.ju:
        return R.image.ju();
      case StoreMachine.mmdx:
        return R.image.mmdx();
      case StoreMachine.nvsv:
        return R.image.nvsv();
      case StoreMachine.pop:
        return R.image.pop();
      case StoreMachine.sdvx:
        return R.image.sdvx();
      case StoreMachine.tko:
        return R.image.tko();
      case StoreMachine.wac:
        return R.image.wac();
      case StoreMachine.x40chu:
        return R.image.x40chu();
      case StoreMachine.x40ddr:
        return R.image.x40ddr();
      case StoreMachine.x40maidx:
        return R.image.x40maidx();
      case StoreMachine.x40sdvx:
        return R.image.x40sdvx();
      case StoreMachine.x40tko:
        return R.image.x40tko();
      case StoreMachine.x40wac:
        return R.image.x40wac();
      case StoreMachine.twoChu:
        return R.image.a2chu();
      case StoreMachine.twoMmdx:
        return R.image.a2mmdx();
      case StoreMachine.twoTko:
        return R.image.a2tko();
      case StoreMachine.twoDm:
        return R.image.a2dm();
      case StoreMachine.twoNos:
        return R.image.a2nos();
      case StoreMachine.twoBom:
        return R.image.a2bom();
      default:
        log('', name: "err _getBackground", error: 'unknown machine: $gameId');
        return R.image.logo_150_jpg();
    }
  }

  ImageProvider getGameCabImage(String gameId) {
    return CachedNetworkImageProvider(
      'https://pay.x50.fun/static/gamesimg/$gameId.png?v1.1',
    );
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
