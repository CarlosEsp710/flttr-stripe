import 'package:dio/dio.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:stripe_app/models/stripe_custom_response.dart';
import 'package:stripe_app/models/payment_intent_response.dart';

class StripeService {
  StripeService._privateConstructor();
  static final StripeService _instance = StripeService._privateConstructor();
  factory StripeService() => _instance;

  final String _paymentApiUrl = "https://api.stripe.com/v1/payment_intents";
  final String _publishableKey = "";
  static String _secretKey = "";

  final headerOptions = Options(
      contentType: Headers.formUrlEncodedContentType,
      headers: {'Authorization': 'Bearer ${StripeService._secretKey}'});
  void init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: _publishableKey,
        androidPayMode: 'test',
        merchantId: 'test',
      ),
    );
  }

  Future payWithExistingCard(
    int amount,
    String currency,
    CreditCard card,
  ) async {
    try {
      final paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card),
      );

      final res = await _charge(amount, currency, paymentMethod);

      return res;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future<StripeCustomResponse> payWithNewCard(
    int amount,
    String currency,
  ) async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );

      final res = await _charge(amount, currency, paymentMethod);

      return res;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future<StripeCustomResponse> payWithService(
    int amount,
    String currency,
  ) async {
    try {
      final token = await StripePayment.paymentRequestWithNativePay(
        androidPayOptions: AndroidPayPaymentRequest(
          currencyCode: currency,
          totalPrice: amount.toString(),
        ),
        applePayOptions: ApplePayPaymentOptions(
          countryCode: 'US',
          currencyCode: currency,
          items: [
            ApplePayItem(label: 'Super producto 1', amount: amount.toString())
          ],
        ),
      );

      final paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(token: token),
      );

      final resp = await _charge(amount, currency, paymentMethod);

      return resp;
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future<PaymentIntentResponse> _paymentIntent(
    int amount,
    String currency,
  ) async {
    try {
      final dio = Dio();

      final response = await dio.post(
        '$_paymentApiUrl?payment_method_types[]=card&amount=${(amount * 100)}&currency=$currency',
        options: headerOptions,
      );

      return PaymentIntentResponse.fromJson(response.data);
    } catch (e) {
      print('Error en intento: ${e.toString()}');
      return PaymentIntentResponse(status: '400');
    }
  }

  Future<StripeCustomResponse> _charge(
    int amount,
    String currency,
    PaymentMethod paymentMethod,
  ) async {
    try {
      final paymentIntent = await _paymentIntent(amount, currency);

      final paymentResult = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent.clientSecret,
          paymentMethodId: paymentMethod.id,
        ),
      );

      if (paymentResult.status == 'succeeded') {
        return StripeCustomResponse(ok: true);
      } else {
        return StripeCustomResponse(
          ok: false,
          msg: 'Falló ${paymentResult.status}',
        );
      }
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }
}
