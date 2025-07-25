import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_list/component/payment_styled_text_red.dart';

class PaymentFailed extends StatefulWidget {
  const PaymentFailed({super.key});

  @override
  State<PaymentFailed> createState() => _PaymentFailedState();
}

class _PaymentFailedState extends State<PaymentFailed> with TickerProviderStateMixin {

  late final AnimationController controller = AnimationController(
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PaymentStyledTextRed(text: 'Payment failed'),
            Lottie.asset(
              height: 125,
              width: 125,
              'visuals/failed.json',
              controller: controller,
              filterQuality: FilterQuality.high,
              onLoaded: (e) {
                controller
                  ..duration = const Duration(seconds: 2)
                  ..repeat();
              }
            ),
          ],
        ),
      ),
    );
  }
}