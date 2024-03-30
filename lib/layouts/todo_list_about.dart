import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class TodoAbout extends StatefulWidget {
  const TodoAbout({super.key});

  @override
  State<TodoAbout> createState() => _TodoAboutState();
}

class _TodoAboutState extends State<TodoAbout> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.w500
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              "Welcome to Minimalist Todo List",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 20.0, thickness: 2),
            Text.rich(
              TextSpan(
                text: "Version: ",
                style: const TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: appVersion,
                    style: const TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            const Text.rich(
              TextSpan(
                text: "Developer: ",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: "TeapotLab",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Description:",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              "Minimalist Todo List is a meticulously crafted task management application designed to simplify your daily routines. Seamlessly engineered to enhance productivity, this robust tool empowers users to effortlessly organize tasks and prioritize responsibilities, facilitating a seamless workflow.\n\n"
              "This innovative application offers a clutter-free interface, fostering an environment conducive to concentration and efficiency. Its intuitive design streamlines task management, enabling users to allocate time effectively and achieve optimal results.\n\n"
              "With Minimalist Todo List, users can delve into their tasks with confidence, knowing that every aspect of their schedule is meticulously organized. From prioritizing deadlines to categorizing tasks by urgency, this versatile application ensures that no detail is overlooked.\n\n"
              "Harnessing the power of technology, Minimalist Todo List transcends traditional task management, offering a comprehensive solution for modern-day challenges. Whether tackling professional projects or managing personal commitments, this indispensable tool serves as a steadfast companion on the journey towards success.\n\n"
              "Elevate your productivity and unlock your full potential with Minimalist Todo List – the ultimate task management solution for individuals seeking simplicity, efficiency, and unparalleled organization.",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Features:",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              "- Add, edit, and delete tasks effortlessly",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
              ),
            ),
            const Text(
              "- Mark tasks as complete",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
              ),
            ),
            const Text(
              "- Organize tasks by categories",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
              ),
            ),
            const Text(
              "- Simple and clean interface",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Contact Us:",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text.rich(
              TextSpan(
                text: "For any inquiries or feedback, please email us at: ",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.normal,
                  fontSize: 12.0,
                ),
                children: [
                  TextSpan(
                    text: "teapotlaboratory@mail.com",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}