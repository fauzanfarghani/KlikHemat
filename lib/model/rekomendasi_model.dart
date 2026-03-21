import 'package:klik_hemat/model/perangkat_model.dart';

class RekomendasiModel {
  String tanggal;
  String title;
  String desc;
  String picture;
  String url;


  RekomendasiModel( this.tanggal, this.title, this.desc, this.picture, this.url);

  Map<String, dynamic> toMap() => {
        'tanggal': tanggal,
        'title': title,
        'desc': desc,
        'picture': picture,
    'url': url
      };

  factory RekomendasiModel.fromMap(Map<Object?, dynamic> data) => RekomendasiModel(
        data['tanggal'],
        data['title'],
        data['desc'],
        data['picture'],
    data['url']
      );
}
