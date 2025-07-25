import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/component/payment_styled_text_white.dart';
import 'package:todo_list/controllers/todo_list_controller.dart';
import 'package:todo_list/services/payment/failed.dart';
import 'package:todo_list/services/payment/success.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';
import 'package:todo_list/component/styled_text_dark.dart';
import 'package:todo_list/component/styled_text_label.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:todo_list/component/styled_text_light_center.dart';
import 'package:todo_list/component/styled_text_purchased.dart';
import 'package:todo_list/component/styled_text_snackbar.dart';
import 'package:todo_list/component/styled_title.dart';
import 'package:http/http.dart' as http;

class FlutterwavePayment extends StatefulWidget {
  const FlutterwavePayment({super.key});

  @override
  State<FlutterwavePayment> createState() => _FlutterwavePaymentState();
}

class _FlutterwavePaymentState extends State<FlutterwavePayment> {

  String? appID;

  String? publicKey;
  var uuid = const Uuid();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verifyEmailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  int emailLength = 0;
  int phoneLength = 0;
  int nameLength = 0;

  bool processing = false;
  bool verifying = false;

  Future<void> initSDK() async {
    await dotenv.load(fileName: ".env");
    publicKey = dotenv.env['livePublicKey'] ?? 'livePublicKey';
  }

  Future<void> initPackageName() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appID = packageInfo.packageName;
    });
  }


  void pay(int amount) async {
    setState(() {
      processing = true;
    });
    // String uniqueTransRef = uuid.v4();
    final name = _nameController.text;
    final phoneNumber = _phoneController.text;
    final email = _emailController.text;

    final Customer customer = Customer(
      name: name,
      phoneNumber: phoneNumber,
      email: email,
    );

    final Flutterwave flutterwave = Flutterwave(
      // TODO: change txRef for each app
      txRef: appID!,
      publicKey: publicKey!,
      currency: "USD",
      redirectUrl: "https://teapotlab.webflow.io/",
      amount: "$amount",
      customer: customer,
      paymentOptions: "ussd, card, barter, payattitude",
      customization: Customization(
        title: "Premium Upgrade",
      ),
      isTestMode: false,
    );

    final ChargeResponse response = await flutterwave.charge(context);

    if (response.success!) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PaymentSuccess()),
      );
    } else {
      setState(() {
        processing = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaymentFailed()),
      );
    }
  }

  void verify() async {
    String email = _verifyEmailController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: StyledTextSnackBar(text: "Please input an email"),
          backgroundColor: Colors.white,
          duration: Duration(seconds: 3),
        )
      );
      return;
    }
    setState(() {
      verifying = true;
    });
    try {
      var response = await http.post(
        // Development
        // Uri.parse('https://flutterwave-customer-verification-api.fly.dev/test/verify/$email/$appID')
        // Live
        Uri.parse('https://flutterwave-customer-verification-api.fly.dev/live/verify/$email/$appID')
      );
      if (response.statusCode >= 200) {
        setState(() {
          verifying = false;
        });
      }
      var data = jsonDecode(response.body);
      if (data['flag'] == 1) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: StyledTextSnackBar(text: "Verified successfully"),
            backgroundColor: Colors.white,
            duration: Duration(seconds: 3),
          )
        );
        Future.delayed(const Duration(seconds: 7), (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PaymentSuccess()));
        });
      } else if(data['flag'] == 0) {
        setState(() {
          verifying = false;
        });
        Navigator.pop(context);
        verifyPurchase(appID);
        ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: StyledTextSnackBar(text: data['message']),
            backgroundColor: Colors.white,
            duration: const Duration(seconds: 3),
          )
        );
      }
    } catch (e) {
      setState(() {
        verifying = false;
      });
      if (context.read<TodoListDatabase>().preferences.first.vibration) Vibration.vibrate(duration: 50);
      ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: StyledTextSnackBar(text: "Something went wrong. Please try again"),
          backgroundColor: Colors.white,
          duration: Duration(seconds: 3),
        )
      );
    }
  }

  void verifyPurchase(appID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 50,
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(child: StyledTitle(text: 'Verify Purchase')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const StyledTextLightCenter(
              text: 'Input your email here',
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _verifyEmailController,
              label: const StyledTextLabel(text: 'Email'),
              icon: Icons.email,
              onChanged: (value) {
              },
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.workspace_premium_rounded,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if(!verifying) verify();
                Navigator.pop(context);
                verifyPurchase(appID);
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(100, 50),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: verifying ? const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              ) : const StyledTextDark(text: 'Verify'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initSDK();
    initPackageName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.workspace_premium_rounded,
                    color: Colors.white,
                    size: 120,
                  ),
                  SizedBox(height: 10),
                  PaymentStyledTextWhite(text: '\$5.00'),
                  SizedBox(height: 40),
                ],
              ),
            ),
            _buildTextField(
              controller: _nameController,
              label: const StyledTextLabel(text: 'Name'),
              icon: Icons.person,
              onChanged: (value) {
                setState(() {
                  nameLength = value.length;
                });
              },
            ),
            const SizedBox(height: 40),
            _buildTextField(
              controller: _phoneController,
              label: const StyledTextLabel(text: 'Phone (+1 1245 767 789)'),
              icon: Icons.phone,
              onChanged: (value) {
                setState(() {
                  phoneLength = value.length;
                });
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: const StyledTextLabel(text: 'Email'),
              icon: Icons.email,
              onChanged: (value) {
                setState(() {
                  emailLength = value.length;
                });
              },
            ),
            const SizedBox(height: 30),
            (nameLength> 2 && phoneLength >= 5 && emailLength >= 4)
              ? ElevatedButton(
                  onPressed: () => {
                    if (!processing) pay(5)
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(225, 50),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  child: !processing ? const StyledTextDark(
                    text: 'Pay',
                  ) : const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      ),
                  )
                )
              : const SizedBox(),
              const SizedBox(
                height: 10,
              ),
            GestureDetector(onTap: () => verifyPurchase(appID), child: const StyledTextPurchased(text: 'Already purchased?'))
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    Widget? label,
    required IconData icon,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontFamily: 'Quicksand'),
      decoration: InputDecoration(
        // filled: true,
        fillColor: Colors.white12,
        // prefixIcon: Icon(icon, color: Colors.white, size: 15),
        label: label,
        // labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          // borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          // borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
