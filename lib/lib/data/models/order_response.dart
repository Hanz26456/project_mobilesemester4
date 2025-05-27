class OrderResponse {
  final int id;
  final String tanggalPemesanan;
  final String metodePembayaran;
  final String status;
  final List<OrderDetailResponse> orderDetails;

  OrderResponse({
    required this.id,
    required this.tanggalPemesanan,
    required this.metodePembayaran,
    required this.status,
    required this.orderDetails,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['id'],
      tanggalPemesanan: json['tanggal_pemesanan'],
      metodePembayaran: json['metode_pembayaran'],
      status: json['status'],
      orderDetails: (json['order_details'] as List)
          .map((e) => OrderDetailResponse.fromJson(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, tanggal: $tanggalPemesanan, status: $status, details: $orderDetails)';
  }
}

class OrderDetailResponse {
  final int serviceId;
  final int quantity;
  final int price;
  final int subtotal;
  final Service service;

  OrderDetailResponse({
    required this.serviceId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.service,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
  return OrderDetailResponse(
    serviceId: int.parse(json['service_id']), // ← perbaikan di sini
    quantity: int.parse(json['quantity']),
    price: int.parse(json['price']),
    subtotal: int.parse(json['subtotal']),
    service: Service.fromJson(json['service']),
  );
}


  @override
  String toString() {
    return 'Detail(serviceId: $serviceId, quantity: $quantity, service: $service)';
  }
}

class Service {
  final String name;

  Service({required this.name});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(name: json['name']); // ✅ perbaikan di sini
  }

  @override
  String toString() {
    return 'Service(name: $name)';
  }
}
