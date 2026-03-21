



class PerangkatModel {
  int id;
  String namaPerangkat;
  String jenisPerangkat;
  double daya;
  double durasiHarian;

  PerangkatModel(this.id,this.namaPerangkat, this.jenisPerangkat, this.daya, this.durasiHarian);

  Map<String, dynamic> toMap() => {
    'id': id,
        'nama_perangkat': namaPerangkat,
        'jenis_perangkat': jenisPerangkat,
        'daya_watt': daya,
        'durasi_harian': durasiHarian,
      };

  factory PerangkatModel.fromMap(Map<Object?, dynamic> data) => PerangkatModel(data['id'],
      data['nama_perangkat'], data['jenis_perangkat'],
      ((data['daya_watt'] ?? data['voltase'] ?? 0) as num).toDouble(), 
      ((data['durasi_harian'] ?? data['ampere'] ?? 0) as num).toDouble());
}
