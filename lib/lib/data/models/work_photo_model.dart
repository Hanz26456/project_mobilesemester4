class WorkPhoto {
  final int id;
  final int orderId;
  final int workerId;
  final String photoBefore;
  final String photoAfter;
  final String? catatan;

  WorkPhoto({
    required this.id,
    required this.orderId,
    required this.workerId,
    required this.photoBefore,
    required this.photoAfter,
    this.catatan,
  });

  factory WorkPhoto.fromJson(Map<String, dynamic> json) {
    return WorkPhoto(
      id: json['id'], // ⬅️ Tambahkan ini
      orderId: json['order_id'],
      workerId: json['worker_id'],
      photoBefore: json['photo_before'],
      photoAfter: json['photo_after'],
      catatan: json['catatan'],
    );
  }
}
