import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:stripe_app/bloc/payment/payment_bloc.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/services/stripe_service.dart';

class PayButton extends StatelessWidget {
  const PayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final blocPayment = BlocProvider.of<PaymentBloc>(context).state;

    return Container(
      width: width,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${blocPayment.total} ${blocPayment.coin}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          BlocBuilder<PaymentBloc, PaymentState>(
            builder: (context, state) {
              return _PaymentMethod(state: state);
            },
          )
        ],
      ),
    );
  }
}

class _PaymentMethod extends StatelessWidget {
  final PaymentState state;

  const _PaymentMethod({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.activeCard
        ? buildCard(context)
        : buildAppleAndGooglePay(context);
  }

  Widget buildCard(BuildContext context) {
    final blocPayment = BlocProvider.of<PaymentBloc>(context).state;
    final stripeService = StripeService();

    return MaterialButton(
      height: 45,
      minWidth: 170,
      shape: const StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      child: Row(
        children: const <Widget>[
          Icon(
            FontAwesomeIcons.solidCreditCard,
            color: Colors.white,
          ),
          Text(
            '   Pagar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ],
      ),
      onPressed: () async {
        showLoading(context);

        final response = await stripeService.payWithExistingCard(
          blocPayment.total,
          blocPayment.coin,
          CreditCard(
            number: blocPayment.card!.cardNumber,
            expMonth: int.parse(blocPayment.card!.expiryDate.split('/')[0]),
            expYear: int.parse(blocPayment.card!.expiryDate.split('/')[1]),
          ),
        );

        Navigator.pop(context);

        if (response.ok) {
          showAlert(context, 'Tarjeta Ok', 'Todo correcto');
        } else {
          showAlert(context, 'Algo salió mal', response.msg.toString());
        }
      },
    );
  }

  Widget buildAppleAndGooglePay(BuildContext context) {
    final blocPayment = BlocProvider.of<PaymentBloc>(context).state;
    final stripeService = StripeService();

    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: const StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      child: Row(
        children: <Widget>[
          Icon(
            Platform.isAndroid
                ? FontAwesomeIcons.google
                : FontAwesomeIcons.apple,
            color: Colors.white,
          ),
          const Text(
            ' Pay',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ],
      ),
      onPressed: () async {
        await stripeService.payWithService(
          blocPayment.total,
          blocPayment.coin,
        );
      },
    );
  }
}
