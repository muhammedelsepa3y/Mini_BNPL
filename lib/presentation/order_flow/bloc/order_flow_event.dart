import 'package:equatable/equatable.dart';

abstract class OrderFlowEvent extends Equatable {
  const OrderFlowEvent();

  @override
  List<Object> get props => [];
}

class CreateOrderEvent extends OrderFlowEvent {
  final int productId;
  final int planId;
  const CreateOrderEvent(this.productId, this.planId);

  @override
  List<Object> get props => [productId, planId];
}

class SubmitPaymentEvent extends OrderFlowEvent {
  final Map<String, dynamic> cardDetails;
  const SubmitPaymentEvent(this.cardDetails);

  @override
  List<Object> get props => [cardDetails];
}
