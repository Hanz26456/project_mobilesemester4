class OrderRequest {
  final int userId;
  final String tanggalPemesanan;
  final String metodePembayaran;
  final List<OrderServiceItem> services;

  OrderRequest({
    required this.userId,
    required this.tanggalPemesanan,
    required this.metodePembayaran,
    required this.services,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId, 
      'tanggal_pemesanan': tanggalPemesanan,
      'metode_pembayaran': metodePembayaran,
      'services': services.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderServiceItem {
  final int serviceId;
  final int quantity;
  final int price;

  OrderServiceItem({
    required this.serviceId,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'quantity': quantity,
      'price': price,
    };
  }
}
