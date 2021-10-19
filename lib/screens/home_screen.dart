import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/bloc/payment/payment_bloc.dart';

import 'package:stripe_app/data/cards.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/screens/card_screen.dart';
import 'package:stripe_app/services/stripe_service.dart';
import 'package:stripe_app/widgets/pay_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final blocPayment = BlocProvider.of<PaymentBloc>(context);
    final stripeService = StripeService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar'),
        actions: [
          IconButton(
            onPressed: () async {
              showLoading(context);

              final response = await stripeService.payWithNewCard(
                blocPayment.state.total,
                blocPayment.state.coin,
              );

              Navigator.pop(context);

              if (response.ok) {
                showAlert(context, 'Tarjeta Ok', 'Todo correcto');
              } else {
                showAlert(context, 'Algo salió mal', response.msg.toString());
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            width: size.width,
            height: size.height,
            top: 200,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.9),
              physics: const BouncingScrollPhysics(),
              itemCount: cards.length,
              itemBuilder: (_, i) {
                final card = cards[i];

                return GestureDetector(
                  onTap: () {
                    blocPayment.add(ActivateCard(card));

                    Navigator.push(
                      context,
                      navigateFadeIn(context, CardScreen(card: card)),
                    );
                  },
                  child: Hero(
                    tag: card.cardNumber,
                    child: CreditCardWidget(
                      cardNumber: card.cardNumber,
                      expiryDate: card.expiryDate,
                      cardHolderName: card.cardHolderName,
                      cvvCode: card.cvvCode,
                      showBackView: false,
                      onCreditCardWidgetChange:
                          (CreditCardBrand creditCardBrand) {},
                    ),
                  ),
                );
              },
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
