import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:stripe_app/models/credit_card.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(const PaymentState()) {
    on<ActivateCard>(
      (event, emit) => emit(
        state.copyWith(
          activeCard: true,
          card: event.card,
        ),
      ),
    );
    on<DesactivateCard>(
      (event, emit) => emit(
        state.copyWith(activeCard: false),
      ),
    );
  }
}
