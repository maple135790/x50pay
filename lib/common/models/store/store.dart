class Store {
  String? prefix;
  List<Storelist>? storelist;

  Store({this.prefix, this.storelist});

  Store.fromJson(Map<String, dynamic> json) {
    prefix = json['prefix'];
    if (json['storelist'] != null) {
      storelist = <Storelist>[];
      json['storelist'].forEach((v) {
        storelist!.add(Storelist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prefix'] = prefix;
    if (storelist != null) {
      data['storelist'] = storelist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Storelist {
  String? address;
  String? name;
  int? sid;

  Storelist({this.address, this.name, this.sid});

  Storelist.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    name = json['name'];
    sid = json['sid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['name'] = name;
    data['sid'] = sid;
    return data;
  }
}
