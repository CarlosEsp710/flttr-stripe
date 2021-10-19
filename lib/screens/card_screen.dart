import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/bloc/payment/payment_bloc.dart';

import 'package:stripe_app/models/credit_card.dart';
import 'package:stripe_app/widgets/pay_button.dart';

class CardScreen extends StatelessWidget {
  final CustomCard card;

  const CardScreen({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocPayment = BlocProvider.of<PaymentBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar'),
        leading: IconButton(
          onPressed: () {
            blocPayment.add(DesactivateCard());
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(),
          Hero(
            tag: card.cardNumber,
            child: CreditCardWidget(
              cardNumber: card.cardNumber,
              expiryDate: card.expiryDate,
              cardHolderName: card.cardHolderName,
              cvvCode: card.cvvCode,
              showBackView: false,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
          ),
          const Positioned(
            bottom: 0,
            child: PayButton(),
          ),
        ],
      ),
    );
  }
}
