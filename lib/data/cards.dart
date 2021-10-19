import 'package:stripe_app/models/credit_card.dart';

final List<CustomCard> cards = <CustomCard>[
  CustomCard(
      cardNumberHidden: '4242',
      cardNumber: '4242424242424242',
      brand: 'visa',
      cvvCode: '213',
      expiryDate: '01/25',
      cardHolderName: 'Fernando Herrera'),
  CustomCard(
      cardNumberHidden: '5555',
      cardNumber: '5555555555554444',
      brand: 'mastercard',
      cvvCode: '213',
      expiryDate: '01/25',
      cardHolderName: 'Melissa Flores'),
  CustomCard(
      cardNumberHidden: '3782',
      cardNumber: '378282246310005',
      brand: 'american express',
      cvvCode: '2134',
      expiryDate: '01/25',
      cardHolderName: 'Eduardo Rios'),
];
