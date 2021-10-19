part of 'payment_bloc.dart';

@immutable
class PaymentState {
  final int total;
  final String coin;
  final bool activeCard;
  final CustomCard? card;

  const PaymentState({
    this.total = 250,
    this.coin = 'MXN',
    this.activeCard = false,
    this.card,
  });

  PaymentState copyWith({
    int? total,
    String? coin,
    bool? activeCard,
    CustomCard? card,
  }) =>
      PaymentState(
        total: total ?? this.total,
        coin: coin ?? this.coin,
        activeCard: activeCard ?? this.activeCard,
        card: card ?? this.card,
      );

  String get amountString => ' ${(total * 100).floor()}';
}
