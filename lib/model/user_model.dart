

class UserModel {
  String email;
  int nomorTelepon;
  String nama;
  String alamat;
  String profileUrl;

  UserModel(this.email, this.nomorTelepon, this.nama, this.alamat,this.profileUrl);

  Map<String, dynamic> toMap() => {
        'email': email,
        'nomor_telepon': nomorTelepon,
        'alamat': alamat,
        'nama': nama,
    'profile_url': profileUrl
      };

  factory UserModel.fromMap(Map<Object?, dynamic> data) => UserModel(
      data['email'], data['nomor_telepon'], data['nama'], data['alamat'], data['profile_url']);
}
