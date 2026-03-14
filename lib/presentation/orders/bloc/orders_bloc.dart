import 'package:bnpl_app/core/usecases/usecase.dart';
import 'package:bnpl_app/domain/entities/order.dart';
import 'package:bnpl_app/domain/usecases/get_orders.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc({required this.getOrders}) : super(OrdersInitial()) {
    on<FetchOrdersEvent>(_onFetchOrders);
  }

  final GetOrders getOrders;

  Future<void> _onFetchOrders(
    FetchOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    final result = await getOrders(NoParams());
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }
}
