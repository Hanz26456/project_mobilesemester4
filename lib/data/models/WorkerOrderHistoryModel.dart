class WorkerOrderHistory {
  final int id;
  final int userId;
  final int? workerId;
  final int totalPembayaran;
  final int kembalian;
  final String tanggalPemesanan;
  final String status;
  final String metodePembayaran;
  final List<OrderDetail> orderDetails;

  WorkerOrderHistory({
    required this.id,
    required this.userId,
    this.workerId,
    required this.totalPembayaran,
    required this.kembalian,
    required this.tanggalPemesanan,
    required this.status,
    required this.metodePembayaran,
    required this.orderDetails,
  });

  factory WorkerOrderHistory.fromJson(Map<String, dynamic> json) {
    return WorkerOrderHistory(
      id: json['id'],
      userId: json['user_id'],
      workerId: json['worker_id'] != null ? json['worker_id'] as int : null,
      totalPembayaran: json['total_pembayaran'],
      kembalian: json['kembalian'],
      tanggalPemesanan: json['tanggal_pemesanan'],
      status: json['status'],
      metodePembayaran: json['metode_pembayaran'],
      orderDetails: (json['order_details'] as List<dynamic>?)
              ?.map((e) => OrderDetail.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OrderDetail {
  final int idOrderDetail;
  final int idOrders;
  final int serviceId;
  final int quantity;
  final int price;
  final int subtotal;
  final Service service;

  OrderDetail({
    required this.idOrderDetail,
    required this.idOrders,
    required this.serviceId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.service,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      idOrderDetail: json['id_order_detail'],
      idOrders: json['id_orders'],
      serviceId: json['service_id'],
      quantity: json['quantity'],
      price: json['price'],
      subtotal: json['subtotal'],
      service: json['service'] != null
          ? Service.fromJson(json['service'])
          : Service(
              id: 0,
              name: 'Unknown',
              description: '',
              price: '0',
              image: null,
            ),
    );
  }
}

class Service {
  final int id;
  final String name;
  final String description;
  final String price;
  final String? image;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toString(),
      image: json['image'],
    );
  }
}
