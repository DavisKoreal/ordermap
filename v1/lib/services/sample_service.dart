import '../models/sample_model.dart';

List<Order> getOrders() {
  return [
    Order(
      id: '1',
      userId: 'anonymous',
      title: 'Sample 1',
      amount: 10.0,
      latitude: 0.0,
      longitude: 0.0,
      status: OrderStatus.unpicked,
    ),
    Order(
      id: '2',
      userId: 'anonymous',
      title: 'Sample 2',
      amount: 20.0,
      latitude: 0.0,
      longitude: 0.0,
      status: OrderStatus.unpicked,
    ),
  ];
}