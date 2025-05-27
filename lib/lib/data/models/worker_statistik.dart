class WorkerStatistik {
  final int totalOrders;
  final double completedPercentage;
  final int totalEarnings;

  WorkerStatistik({
    required this.totalOrders,
    required this.completedPercentage,
    required this.totalEarnings,
  });

  factory WorkerStatistik.fromJson(Map<String, dynamic> json) {
    return WorkerStatistik(
      totalOrders: json['total_orders'] is String 
          ? int.parse(json['total_orders']) 
          : json['total_orders'],
      completedPercentage: (json['completed_percentage'] is String 
          ? double.parse(json['completed_percentage']) 
          : json['completed_percentage']).toDouble(),
      totalEarnings: json['total_earnings'] is String 
          ? int.parse(json['total_earnings']) 
          : json['total_earnings'],
    );
  }

  // Method untuk debugging
  @override
  String toString() {
    return 'WorkerStatistik(totalOrders: $totalOrders, completedPercentage: $completedPercentage, totalEarnings: $totalEarnings)';
  }
}