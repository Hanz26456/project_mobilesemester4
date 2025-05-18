class OrderPekerja {
  final int id;
  final String namaUser;
  final String alamat;
  final String service;
  final String status;
  final String tanggalPemesanan;

  OrderPekerja({
    required this.id,
    required this.namaUser,
    required this.alamat,
    required this.service,
    required this.status,
    required this.tanggalPemesanan,
  });

  factory OrderPekerja.fromJson(Map<String, dynamic> json) {
    return OrderPekerja(
      id: json['id'] ?? 0,
      namaUser: json['user'] != null
          ? (json['user']['username'] ?? '')
          : '',
      alamat: json['user'] != null
          ? (json['user']['address'] ?? '')
          : '',
      service: (json['order_details'] != null && json['order_details'].isNotEmpty && json['order_details'][0]['service'] != null)
          ? (json['order_details'][0]['service']['name'] ?? '')
          : '',
      status: json['status'] ?? '',
      tanggalPemesanan: json['created_at'] ?? '',
    );
  }
}
