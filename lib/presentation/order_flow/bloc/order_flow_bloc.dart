import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/check_payment_card.dart';
import '../../../domain/usecases/create_new_order.dart';
import 'order_flow_event.dart';
import 'order_flow_state.dart';

class OrderFlowBloc extends Bloc<OrderFlowEvent, OrderFlowState> {
  final CreateOrder createOrder;
  final CheckCard checkCard;

  OrderFlowBloc({
    required this.createOrder,
    required this.checkCard,
  }) : super(OrderFlowInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<SubmitPaymentEvent>(_onSubmitPayment);
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderFlowState> emit,
  ) async {
    emit(OrderFlowLoading());
    final result = await createOrder(CreateOrderParams(
      productId: event.productId,
      planId: event.planId,
    ));
    result.fold(
      (failure) => emit(OrderFlowError(failure.message)),
      (orderId) => emit(OrderCreatedSuccess(orderId)),
    );
  }

  Future<void> _onSubmitPayment(
    SubmitPaymentEvent event,
    Emitter<OrderFlowState> emit,
  ) async {
    emit(OrderFlowLoading());
    final result = await checkCard(CheckCardParams(
      cardDetails: event.cardDetails,
    ));
    result.fold(
      (failure) => emit(OrderFlowError(failure.message)),
      (success) {
        if (success) {
          emit(PaymentSuccess());
        } else {
          emit(const OrderFlowError('Payment failed or declined.'));
        }
      },
    );
  }
}
