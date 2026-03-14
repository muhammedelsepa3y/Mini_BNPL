import 'package:bnpl_app/domain/usecases/check_payment_card.dart';
import 'package:bnpl_app/domain/usecases/create_new_order.dart';
import 'package:bnpl_app/presentation/order_flow/bloc/order_flow_event.dart';
import 'package:bnpl_app/presentation/order_flow/bloc/order_flow_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderFlowBloc extends Bloc<OrderFlowEvent, OrderFlowState> {
  OrderFlowBloc({
    required this.createOrder,
    required this.checkCard,
  }) : super(OrderFlowInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<SubmitPaymentEvent>(_onSubmitPayment);
  }

  final CreateNewOrder createOrder;
  final CheckPaymentCard checkCard;

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderFlowState> emit,
  ) async {
    emit(OrderFlowLoading());
    final result = await createOrder(
      CreateOrderParams(
        productId: event.productId,
        planId: event.planId,
      ),
    );
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
    final result = await checkCard(
      CheckCardParams(
        cardDetails: event.cardDetails,
      ),
    );
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
