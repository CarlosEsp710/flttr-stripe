import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FullPaymentScreen extends StatelessWidget {
  const FullPaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago realizado'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(
              FontAwesomeIcons.star,
              color: Colors.white54,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Pago realizado correctamente!',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
