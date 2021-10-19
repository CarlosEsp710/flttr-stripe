part of 'payment_bloc.dart';

@immutable
abstract class PaymentEvent {}

class ActivateCard extends PaymentEvent {
  final CustomCard card;

  ActivateCard(this.card);
}

class DesactivateCard extends PaymentEvent {}
