import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:loginpages/controller.dart';
import 'package:loginpages/hive.dart';
import 'package:loginpages/home_screen.dart';
import 'package:loginpages/hover_cursore.dart';

import 'package:loginpages/register_page.dart';
import 'package:loading_btn/loading_btn.dart';
class LogininScreen extends StatefulWidget {
  const LogininScreen({super.key});

  @override
  State<LogininScreen> createState() => _LogininScreenState();
}

class _LogininScreenState extends State<LogininScreen>
    with SingleTickerProviderStateMixin {
  final LoginPageController controller = Get.put(LoginPageController());
  final formkey = GlobalKey<FormState>();
  Color boxcolor = Colors.orange;
  bool isPlaying = false;
  final confetticontroller =
      ConfettiController(duration: const Duration(milliseconds: 200));

  bool obscureText = true;
  Text buttonText = const Text(
    'Login',
    style: TextStyle(color: Colors.white),
  );

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    confetticontroller.addListener(() {
      isPlaying = confetticontroller.state == ConfettiControllerState.playing;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    confetticontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = context.height;
    double screenWidth = context.width;

    return GetBuilder<LoginPageController>(builder: (_) {
      void passwordEye() {
        controller.loginobscureText = !controller.loginobscureText;
        controller.update();
      }

      return Stack(alignment: Alignment.center, children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.orange,
            title: const Text(
              "Login Page",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight - .93 * context.height,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text("Log-In",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                ),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        width: screenWidth - 20,
                        child: TextFormField(
                          controller: controller.loginpageemailcontrolller,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.black,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              labelText: "Email Address",
                              labelStyle: TextStyle(color: Colors.grey)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email address is not valid';
                            } else if (!value.contains("@")) {
                              return 'Email address is not valid';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: screenHeight - 0.96 * screenHeight,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        width: screenWidth - 20,
                        child: TextFormField(
                          controller: controller.loginpagepasswordcontroller,
                          keyboardType: TextInputType.visiblePassword,
                          cursorColor: Colors.black,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              labelText: "Password",
                              labelStyle: const TextStyle(color: Colors.grey),
                              suffixIcon: IconButton(
                                  onPressed: passwordEye,
                                  icon: Icon(
                                    controller.loginobscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.black54,
                                  ))),
                          obscureText: controller.loginobscureText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please choose a strong password";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: context.width - 0.98 * context.width,
                ),
                SizedBox(
                  height: screenHeight - 0.93 * screenHeight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: LoadingBtn(
                            roundLoadingShape: false,
                            loader: AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Transform(
                                  transform: Matrix4.identity()
                                    ..rotateX(
                                        _animationController.value * 2 * pi),
                                  alignment: Alignment.center,
                                  child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: const BoxDecoration(
                                          color: Colors.orange,
                                          shape: BoxShape.rectangle)),
                                );
                              },
                            ),
                            height: 50,
                            width: Get.width - 40,
                            animate: true,
                            color: boxcolor,
                            onTap: (startLoading, stopLoading, btnState) async {
                              FocusScope.of(context).unfocus();
                              if (btnState == ButtonState.idle) {
                                if (formkey.currentState!.validate()) {
                                  startLoading();
                                  _animationController.repeat();
                                  setState(() {
                                    boxcolor = Colors.white;
                                  });
                                }

                                await Future.delayed(
                                    const Duration(seconds: 5));
                                _animationController.stop();
                                _animationController.reset();
                                setState(() {
                                  boxcolor = Colors.orange;
                                });
                                stopLoading();

                                if (formkey.currentState!.validate()) {
                                  if (controller.storedLoginIdPasswords.any(
                                      (id) =>
                                          id['EmailID'] ==
                                              controller
                                                  .loginpageemailcontrolller
                                                  .text &&
                                          id['password'] ==
                                              controller
                                                  .loginpagepasswordcontroller
                                                  .text)) {
                                    if (controller
                                            .loginpageemailcontrolller.text ==
                                        'test1@gmail.com') {
                                      setState(() {
                                        boxcolor = Colors.green;
                                        buttonText = const Text(
                                          'Authenticate Sucess',
                                          style: TextStyle(color: Colors.white),
                                        );
                                      });

                                      await Future.delayed(
                                          const Duration(microseconds: 500));

                                      confetticontroller.play();
                                      await Future.delayed(
                                          const Duration(seconds: 2));

                                      Get.to(() => const DragCircle() );
                                      setState(() {
                                        boxcolor = Colors.orange;
                                        buttonText = const Text(
                                          'Login',
                                          style: TextStyle(color: Colors.white),
                                        );
                                      });
                                      confetticontroller.stop();

                                      box1.put(
                                          'DataUser1', controller.dataUser1);
                                    } else if (controller
                                            .loginpageemailcontrolller.text ==
                                        'test2@gmail.com') {
                                      setState(() {
                                        boxcolor = Colors.green;
                                        buttonText = const Text(
                                          'Authenticate Sucess',
                                          style: TextStyle(color: Colors.white),
                                        );
                                      });
                                      await Future.delayed(
                                          const Duration(seconds: 2));
                                      Get.to(() => HomeScreen(
                                          appTitle: controller
                                              .loginpageemailcontrolller.text,
                                          data: controller.dataUser2));
                                      box1.put(
                                          'DataUser2', controller.dataUser2);
                                    } else {
                                      setState(() {
                                        boxcolor = Colors.green;
                                        buttonText = const Text(
                                          'Authenticate Sucess',
                                          style: TextStyle(color: Colors.white),
                                        );
                                      });
                                      Future.delayed(
                                          const Duration(seconds: 2));
                                      Get.to(() => HomeScreen(
                                          appTitle: controller
                                              .loginpageemailcontrolller.text,
                                          data: controller.data));

                                      box1.put('Data', controller.data);
                                    }

                                    Get.closeAllSnackbars();
                                    Get.snackbar(
                                        snackPosition: SnackPosition.BOTTOM,
                                        'Sucess',
                                        'loginSucessfully');
                                  } else {
                                    Get.snackbar(
                                        snackPosition: SnackPosition.BOTTOM,
                                        'Incorrect',
                                        'Enter Valid EmailAddress or password');
                                  }
                                }
                              }
                            },
                            child: buttonText))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("New User? "),
                    GestureDetector(
                        onTap: () {
                          Get.to(() => const RegisterScreen());
                          controller.loginpageemailcontrolller.clear();
                          controller.loginpagepasswordcontroller.clear();
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
        ConfettiWidget(
          canvas: Size(Get.width, Get.height),
          particleDrag: 0.2,
          confettiController: confetticontroller,
          shouldLoop: false,
          blastDirectionality: BlastDirectionality.explosive,
          blastDirection: pi * 2,
          numberOfParticles: 10,
          minBlastForce: 500,
          maxBlastForce: 1000,
          emissionFrequency: 0.80,
          displayTarget: false,
          colors: const [
            Colors.green,
            Color.fromARGB(255, 118, 183, 236),
            Color.fromARGB(255, 227, 180, 163),
            Color.fromARGB(255, 235, 137, 130),
            Color.fromARGB(255, 229, 185, 119),
            Color.fromARGB(255, 124, 222, 227),
            Color.fromARGB(255, 250, 145, 233),
            Color.fromARGB(255, 190, 144, 240),
            Color.fromARGB(238, 217, 72, 200),
            Color.fromARGB(255, 208, 80, 60),
          ],
          gravity: 0.8,
          createParticlePath: (size) {
            final path = Path();

            path.addOval(Rect.fromCircle(center: Offset.zero, radius: 7));
            return path;
          },
        )
      ]);
    });
  }
}
