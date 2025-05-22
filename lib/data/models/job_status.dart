class JobStatus {
  final int proses;
  final int selesaiPengerjaan;
  final int selesai;

  JobStatus({
    required this.proses,
    required this.selesaiPengerjaan,
    required this.selesai,
  });

  factory JobStatus.fromJson(Map<String, dynamic> json) {
    return JobStatus(
      proses: json['proses'] ?? 0,
      selesaiPengerjaan: json['selesai_pengerjaan'] ?? 0,
      selesai: json['selesai'] ?? 0,
    );
  }
}
