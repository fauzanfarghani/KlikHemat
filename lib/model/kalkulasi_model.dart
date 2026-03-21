import 'dart:convert';

import 'package:klik_hemat/model/perangkat_model.dart';

class KalkulasiModel {
  int time;
  String periode;
  double totalKwh;
  double totalBiaya;
  List<PerangkatModel> perangkat;

  KalkulasiModel(
      this.time, this.periode, this.totalKwh, this.totalBiaya, this.perangkat);

  Map<String, dynamic> toMap() => {
        'time': time,
        'periode': periode,
        'totalKwh': totalKwh,
        'totalBiaya': totalBiaya,
        'perangkat': jsonEncode(List<dynamic>.from(perangkat.map((x) => x.toMap())))
      };

  factory KalkulasiModel.fromMap(Map<Object?, dynamic> data) => KalkulasiModel(
        data['time'],
        data['periode'],
    data['totalKwh'].runtimeType == double ? data['totalKwh'] : (data['totalKwh'] as int).toDouble(),
      data['totalBiaya'].runtimeType == double ? data['totalBiaya'] : (data['totalBiaya'] as int).toDouble(),
        List<PerangkatModel>.from(jsonDecode(data["perangkat"]).map((x) => PerangkatModel.fromMap(x))),
      );
}
