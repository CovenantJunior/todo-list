import 'package:flutter/material.dart';

class TodoPrivacy extends StatelessWidget {
  const TodoPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                children: [
                  TextSpan(
                    text:
                        "This Privacy Policy governs the manner in which Minimalist Todo List (referred to as 'us', 'we', or 'our') collects, uses, maintains, and discloses information collected from users (each, a 'User') of the Minimalist Todo List mobile application (referred to as 'the App').\n\n",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text: "1. Information Collection\n\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  TextSpan(
                    text: "1.1 Voice Input:\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text:
                        "The Minimalist Todo List App utilizes voice input for speech-to-text (STT) functionality, enabling users to dictate tasks and notes within the application. We do not store or transmit voice recordings to our servers or any third parties. Voice input is processed locally on the user's device.\n\n",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text: "1.2 IP Address:\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text:
                        "In order to enhance user experience and improve our services, we may collect and store the IP addresses of Users for usage reference and to analyze trends. However, we do not link IP addresses to any personally identifiable information.\n\n",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text: "2. Use of Information\n\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  TextSpan(
                    text: "2.1 Voice Input:\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text:
                        "Voice input data collected by the App is solely used for the purpose of converting speech to text within the application. This information is not stored or shared with any external parties.\n\n",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text: "2.2 IP Address:\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text:
                        "The IP addresses collected from Users may be used for internal purposes such as troubleshooting, analyzing trends, and enhancing the overall performance and functionality of the App. We do not disclose IP addresses to third parties unless required by law.\n\n",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text: "3. Internet Connection\n\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  TextSpan(
                    text:
                        "The Minimalist Todo List App requires an internet connection for certain features, including but not limited to Google Drive backup functionality. Your usage of these features may be subject to the terms and policies of the respective service providers. We recommend reviewing the privacy policies of these third-party services for more information on their data practices.\n\n",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text: "4. Children's Privacy\n\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  TextSpan(
                    text:
                        "The Minimalist Todo List App is not directed at individuals under the age of 13 ('Children'). We do not knowingly collect personal information from Children. If you are a parent or guardian and you are aware that your Child has provided us with personal information, please contact us. If we become aware that we have collected personal information from children without verification of parental consent, we take steps to remove that information from our servers.\n\n",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text: "5. Contact Us\n\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  TextSpan(
                    text:
                        "If you have any questions about this Privacy Policy or the practices of the Minimalist Todo List App, please contact us at teapotlaboratory@gmail.com.\n\n",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text: "6. Changes to this Privacy Policy\n\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  TextSpan(
                    text:
                        "We reserve the right to update or modify this Privacy Policy at any time, without prior notice. We encourage Users to frequently check this page for any changes to stay informed about how we are helping to protect the personal information we collect. You acknowledge and agree that it is your responsibility to review this Privacy Policy periodically and become aware of modifications.",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
