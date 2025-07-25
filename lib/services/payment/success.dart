import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/component/payment_styled_text_green.dart';
import 'package:todo_list/component/styled_text.dart';
import 'package:todo_list/controllers/todo_list_controller.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({super.key});

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> with TickerProviderStateMixin {

  late final AnimationController controller = AnimationController(
    vsync: this,
  );

   void upgrade() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: StyledText(text: 'Upgrading...'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),
      );
      // context.read<SettingDatabase>().setVideoQuality('High');
      context.read<TodoListDatabase>().turnOffAds(1);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PaymentStyledTextGreen(text: 'Payment successful'),
            Lottie.asset(
              'visuals/success.json',
              controller: controller,
              filterQuality: FilterQuality.high,
              onLoaded: (e) {
                controller
                  ..duration = const Duration(seconds: 2)
                  ..repeat();
                  upgrade();
              }
            ),
          ],
        ),
      ),
      bottomSheet: const LinearProgressIndicator(
        color: Colors.green,
        backgroundColor: Colors.black,
      ),
    );
  }
}
