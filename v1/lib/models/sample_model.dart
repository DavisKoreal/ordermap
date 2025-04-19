enum OrderStatus { picked, unpicked }

class Order {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final double latitude;
  final double longitude;
  final OrderStatus status;

  Order({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.latitude,
    required this.longitude,
    this.status = OrderStatus.unpicked,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'amount': amount,
      'latitude': latitude,
      'longitude': longitude,
      'status': status.name,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      userId: map['userId'] ?? 'anonymous',
      title: map['title'],
      amount: map['amount'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.unpicked,
      ),
    );
  }
}