class WorkPhoto {
  final int orderId;
  final int workerId;
  final String? photoBefore;
  final String? photoAfter;
  final String? catatan;

  WorkPhoto({
    required this.orderId,
    required this.workerId,
    this.photoBefore,
    this.photoAfter,
    this.catatan,
  });

  factory WorkPhoto.fromJson(Map<String, dynamic> json) {
    return WorkPhoto(
      orderId: json['order_id'],
      workerId: json['worker_id'],
      photoBefore: json['photo_before'],
      photoAfter: json['photo_after'],
      catatan: json['catatan'],
    );
  }
}
