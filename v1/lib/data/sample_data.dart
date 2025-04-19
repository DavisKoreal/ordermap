import '../models/sample_model.dart';

List<Order> getSampleOrders() {
  return [
    Order(
      id: '1',
      userId: 'anonymous',
      title: 'Order 1',
      amount: 29.99,
      latitude: 37.7749,
      longitude: -122.4194,
      status: OrderStatus.unpicked,
    ),
    Order(
      id: '2',
      userId: 'anonymous',
      title: 'Order 2',
      amount: 59.99,
      latitude: 37.7849,
      longitude: -122.4094,
      status: OrderStatus.picked,
    ),
    Order(
      id: '3',
      userId: 'anonymous',
      title: 'Order 3',
      amount: 19.99,
      latitude: 37.7649,
      longitude: -122.4294,
      status: OrderStatus.unpicked,
    ),
  ];
}