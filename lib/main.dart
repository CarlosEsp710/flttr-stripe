import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_app/bloc/payment/payment_bloc.dart';

import 'package:stripe_app/screens/home_screen.dart';
import 'package:stripe_app/screens/full_payment_screen.dart';
import 'package:stripe_app/services/stripe_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StripeService().init();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PaymentBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stripe App',
        initialRoute: 'home',
        routes: {
          'home': (_) => const HomeScreen(),
          'full_payment': (_) => const FullPaymentScreen(),
        },
        theme: ThemeData.light().copyWith(
          primaryColor: const Color(0xff284879),
          appBarTheme: const AppBarTheme(
            color: Color(0xff284879),
            centerTitle: true,
            elevation: 0,
          ),
          scaffoldBackgroundColor: const Color(0xff21232A),
        ),
      ),
    );
  }
}
