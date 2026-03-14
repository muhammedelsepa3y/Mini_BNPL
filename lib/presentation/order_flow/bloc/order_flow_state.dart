import 'package:equatable/equatable.dart';

abstract class OrderFlowState extends Equatable {
  const OrderFlowState();

  @override
  List<Object> get props => [];
}

class OrderFlowInitial extends OrderFlowState {}

class OrderFlowLoading extends OrderFlowState {}

class OrderCreatedSuccess extends OrderFlowState {
  const OrderCreatedSuccess(this.orderId);

  final int orderId;

  @override
  List<Object> get props => [orderId];
}

class OrderFlowError extends OrderFlowState {
  const OrderFlowError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class PaymentSuccess extends OrderFlowState {}
