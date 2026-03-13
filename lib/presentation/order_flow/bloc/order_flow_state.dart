import 'package:equatable/equatable.dart';

abstract class OrderFlowState extends Equatable {
  const OrderFlowState();

  @override
  List<Object> get props => [];
}

class OrderFlowInitial extends OrderFlowState {}

class OrderFlowLoading extends OrderFlowState {}

class OrderCreatedSuccess extends OrderFlowState {
  final int orderId;
  const OrderCreatedSuccess(this.orderId);

  @override
  List<Object> get props => [orderId];
}
class OrderFlowError extends OrderFlowState {
  final String message;
  const OrderFlowError(this.message);

  @override
  List<Object> get props => [message];
}

class PaymentSuccess extends OrderFlowState {}


