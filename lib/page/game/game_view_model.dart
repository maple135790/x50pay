import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/repository/repository.dart';

class GameViewModel extends BaseViewModel {
  Repository repo = Repository();
  Store? stores;
  String? storeName;
  Gamelist? gamelist;
  User? user;

  Future<bool> initStore() async {
    try {
      await EasyLoading.show();
      await Future.delayed(const Duration(milliseconds: 100));
      stores ??= Store.fromJson(jsonDecode(testStorelist));
      user ??= await getUser();
      GlobalSingleton.instance.user = user;
      await EasyLoading.dismiss();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<User>? getUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return testUser;
  }

  Future<bool> hasRecentStore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('store_id') != null || prefs.getString('store_name') != null;
  }

  Future<bool> canGetGamelist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString('store_id');
      if (sid == null) return false;
      if (!kDebugMode) {
        gamelist = await repo.getGameList(sid);
      } else {
        print('current sid == $sid');
        storeName = await prefs.getString('store_name');
        if (sid == '37656') gamelist = Gamelist.fromJson(jsonDecode(testGamelistWOLIN));
        if (sid == '37657') gamelist = Gamelist.fromJson(jsonDecode(testGamelistSHILIN));
      }
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  String testStorelist = '''
{
  "prefix": "70",
  "storelist": [
{
  "address": "臺北市萬華區武昌街二段134號1樓",
  "name": "西門店",
  "sid": 37656
},
{
  "address": "臺北市士林區大南路48號2樓",
  "name": "士林店",
  "sid": 37657
}
  ]
}

''';
  String testGamelistWOLIN = '''
{
  "message": "done",
  "code": 200,
  "machinelist": [
    {
      "lable": "[西門] CHUNITHM",
      "price": 9,
      "discount": 9,
      "downprice": [
        25,
        1
      ],
      "mode": [
        [
          0,
          "單人遊玩",
          25,
          true
        ]
      ],
      "note": [
        3,
        "A組一回",
        false,
        "four"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "最左"
        },
        "1": {
          "notice": "中左"
        },
        "2": {
          "notice": "中右"
        },
        "3": {
          "notice": "最右"
        }
      },
      "cabinet": 3,
      "enable": true,
      "id": "chu",
      "shop": "7037656",
      "lora": true,
      "pad": true,
      "padlid": "chu",
      "padmid": "50Pad04",
      "qcounter": [
        0,
        0,
        0,
        0
      ],
      "quic": true,
      "vipb": true
    },
    {
      "lable": "[西門] maimai DX",
      "price": 9,
      "discount": 9,
      "downprice": [
        25,
        1,
        2
      ],
      "mode": [
        [
          0,
          "單人遊玩",
          25,
          true
        ],
        [
          1,
          "雙人遊玩 (計兩道)",
          50,
          true
        ]
      ],
      "note": [
        1,
        "一回制臺",
        "一回制臺",
        false,
        "twor"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "右臺"
        },
        "1": {
          "notice": "左臺"
        },
        "2": {
          "notice": "左後"
        }
      },
      "cabinet": 2,
      "enable": true,
      "id": "mmdx",
      "shop": "7037656",
      "lora": true,
      "pad": true,
      "padlid": "mmdx",
      "padmid": "50Pad01",
      "vipb": true
    },
    {
      "lable": "[西門] SOUND VOLTEX",
      "price": 9,
      "discount": 8,
      "downprice": "",
      "mode": [
        [
          0,
          "Light",
          16,
          true
        ],
        [
          1,
          "Standard",
          24,
          true
        ],
        [
          2,
          "Premium Time",
          32,
          true
        ],
        [
          3,
          "Blaster (普時計兩道)",
          40,
          true
        ]
      ],
      "note": [
        1,
        "舊框體一回制",
        false,
        "two"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "左臺",
          "price": [
            10,
            9,
            9,
            9
          ],
          "discount": [
            10,
            8,
            8,
            8
          ]
        },
        "1": {
          "notice": "右臺",
          "price": [
            10,
            9,
            9,
            9
          ],
          "discount": [
            10,
            8,
            8,
            8
          ]
        }
      },
      "cabinet": 1,
      "enable": true,
      "id": "sdvx",
      "shop": "7037656",
      "lora": true,
      "vipb": true
    },
    {
      "lable": "[西門] WACCA",
      "price": 10,
      "discount": 10,
      "downprice": null,
      "mode": [
        [
          0,
          "單人遊玩",
          20,
          false
        ]
      ],
      "note": [
        1,
        "一回制",
        false,
        "two"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "左臺"
        },
        "1": {
          "notice": "右臺"
        }
      },
      "cabinet": 1,
      "enable": true,
      "id": "wac",
      "shop": "7037656",
      "lora": false,
      "pad": true,
      "padlid": "wac",
      "padmid": "50Pad02",
      "vipb": false
    },
    {
      "lable": "[西門] 太鼓の達人",
      "price": 9,
      "discount": 9,
      "downprice": [
        25,
        1,
        2
      ],
      "mode": [
        [
          0,
          "單人遊玩",
          25,
          true
        ],
        [
          1,
          "雙人遊玩 (計兩道)",
          50,
          true
        ]
      ],
      "note": [
        0,
        "彩虹版 四曲設定",
        false,
        "one"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "沙發旁"
        }
      },
      "cabinet": 0,
      "enable": true,
      "id": "tko",
      "shop": "7037656",
      "lora": true,
      "pad": true,
      "padlid": "tko",
      "padmid": "50Pad02",
      "vipb": true
    },
    {
      "lable": "[西門] DanceDanceRevolution",
      "price": 9,
      "discount": 9,
      "downprice": [
        25,
        1,
        2
      ],
      "mode": [
        [
          0,
          "單人遊玩",
          25,
          true
        ],
        [
          1,
          "雙人遊玩 (計兩道)",
          50,
          true
        ]
      ],
      "note": [
        0,
        "A20 Plus",
        false,
        "one"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "GC 旁"
        }
      },
      "cabinet": 0,
      "enable": true,
      "id": "ddr",
      "shop": "7037656",
      "lora": true,
      "vipb": true
    },
    {
      "lable": "[西門] GROOVE COASTER",
      "price": 10,
      "discount": 10,
      "downprice": [],
      "mode": [
        [
          0,
          "單人遊玩",
          20,
          false
        ]
      ],
      "note": [
        0,
        "4 Max",
        false,
        "one"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "DDR 旁"
        }
      },
      "cabinet": 0,
      "enable": true,
      "id": "gc",
      "shop": "7037656",
      "lora": true,
      "vipb": false
    },
    {
      "lable": "[西門] pop'n music",
      "price": 10,
      "discount": 9,
      "downprice": [],
      "mode": [
        [
          0,
          "單人遊玩",
          30,
          false
        ]
      ],
      "note": [
        0,
        "pop’n music 解明リドルズ",
        false,
        "one"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "Jubeat 旁"
        }
      },
      "cabinet": 0,
      "enable": true,
      "id": "pop",
      "shop": "7037656",
      "lora": true,
      "vipb": false
    },
    {
      "lable": "[西門] Jubeat",
      "price": 10,
      "discount": 9.5,
      "downprice": [],
      "mode": [
        [
          0,
          "單人遊玩",
          19,
          true
        ]
      ],
      "note": [
        0,
        "Jubeat festo",
        false,
        "one"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "pop'n 旁"
        }
      },
      "cabinet": 0,
      "enable": true,
      "id": "ju",
      "shop": "7037656",
      "lora": true,
      "vipb": true
    },
    {
      "lable": "[西門] SDVX - Valkyrie Model",
      "price": 9,
      "discount": 8,
      "downprice": "",
      "mode": [
        [
          0,
          "Light/Arena/Mega",
          36,
          false
        ],
        [
          1,
          "Standard (計兩道)",
          45,
          false
        ],
        [
          2,
          "Blaster/Premium (計兩道)",
          54,
          false
        ]
      ],
      "note": [
        1,
        "新框體一回制",
        false,
        "two"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "(左台)"
        },
        "1": {
          "notice": "(右台)"
        }
      },
      "cabinet": 1,
      "enable": true,
      "id": "nvsv",
      "shop": "7037656",
      "lora": false,
      "pad": true,
      "padlid": "nvsv",
      "padmid": "50Pad04",
      "vipb": false
    }
  ],
  "payMid": null,
  "payLid": null,
  "payCid": null
}
''';

  String testGamelistSHILIN = '''
{
  "message": "done",
  "code": 200,
  "machinelist": [
    {
      "lable": "[士林] maimai DX ",
      "price": 9,
      "discount": 9,
      "downprice": "",
      "mode": [
        [
          0,
          "單人遊玩",
          27,
          false
        ],
        [
          1,
          "雙人遊玩",
          54,
          false
        ]
      ],
      "note": [
        1,
        "一回制臺",
        true,
        "two"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "右臺"
        },
        "1": {
          "notice": "左臺"
        }
      },
      "cabinet": 1,
      "enable": true,
      "id": "x40maidx",
      "shop": "7037657",
      "lora": false,
      "vipb": false
    },
    {
      "lable": "[士林] 太鼓の達人",
      "price": 10,
      "discount": 9,
      "downprice": "",
      "mode": [
        [
          0,
          "單人遊玩",
          30,
          false
        ]
      ],
      "note": [
        0,
        "彩虹版 三曲設定",
        false,
        "one"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "一樓"
        }
      },
      "cabinet": 0,
      "enable": true,
      "id": "x40tko",
      "shop": "7037657",
      "lora": false,
      "vipb": false
    },
    {
      "lable": "[士林] Dance Dance Revolution",
      "price": 10,
      "discount": 9,
      "downprice": [],
      "mode": [
        [
          0,
          "單人遊玩",
          30,
          false
        ]
      ],
      "note": [
        0,
        "A20 Plus",
        false,
        "one"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "中二後方"
        }
      },
      "cabinet": 0,
      "enable": true,
      "id": "x40ddr",
      "shop": "7037657",
      "lora": false,
      "vipb": false
    },
    {
      "lable": "[士林] SOUND VOLTEX",
      "price": 10,
      "discount": 9,
      "downprice": "",
      "mode": [
        [
          0,
          "Light/Standard",
          30,
          false
        ],
        [
          1,
          "Blaster/Paradise",
          50,
          false
        ]
      ],
      "note": [
        0,
        "舊框體一回制",
        false,
        "two"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "左台"
        },
        "1": {
          "notice": "右台"
        }
      },
      "cabinet": 1,
      "enable": true,
      "id": "x40sdvx",
      "shop": "7037657",
      "lora": false,
      "vipb": false
    },
    {
      "lable": "[士林] CHUNITHM",
      "price": 9,
      "discount": 9,
      "downprice": "",
      "mode": [
        [
          0,
          "單人遊玩",
          27,
          false
        ]
      ],
      "note": [
        2,
        "一回限",
        false,
        "two"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "(左台)"
        },
        "1": {
          "notice": "(右台)"
        }
      },
      "cabinet": 1,
      "enable": true,
      "id": "x40chu",
      "shop": "7037657",
      "lora": false,
      "vipb": false
    },
    {
      "lable": "[士林] WACCA",
      "price": 10,
      "discount": 10,
      "downprice": "",
      "mode": [
        [
          0,
          "一道",
          20,
          false
        ]
      ],
      "note": [
        1,
        "一回制",
        false,
        "two"
      ],
      "cabinet_detail": {
        "0": {
          "notice": "左台"
        },
        "1": {
          "notice": "右台"
        }
      },
      "cabinet": 1,
      "enable": true,
      "id": "x40wac",
      "shop": "7037657",
      "lora": false,
      "vipb": false
    }
  ],
  "payMid": null,
  "payLid": null,
  "payCid": null
}
''';
}
