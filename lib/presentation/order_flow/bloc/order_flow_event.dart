import 'package:equatable/equatable.dart';

abstract class OrderFlowEvent extends Equatable {
  const OrderFlowEvent();

  @override
  List<Object> get props => [];
}

class CreateOrderEvent extends OrderFlowEvent {
  const CreateOrderEvent(this.productId, this.planId);

  final int productId;
  final int planId;

  @override
  List<Object> get props => [productId, planId];
}

class SubmitPaymentEvent extends OrderFlowEvent {
  const SubmitPaymentEvent(this.cardDetails, this.orderId);

  final Map<String, dynamic> cardDetails;
  final int orderId;

  @override
  List<Object> get props => [cardDetails, orderId];
}
