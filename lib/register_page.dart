import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginpages/controller.dart';
import 'package:loginpages/hive.dart';

import 'package:loginpages/login_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final LoginPageController controller = Get.put(LoginPageController());
  @override
  void initState() {
    super.initState();

    List<dynamic> x = box.get('IDPassword') ?? [];

    List<Map<String, String>> storedLoginIdPasswords = [];

    for (var element in x) {
      if (element is Map) {
        var email = element['EmailID'];
        var password = element['password'];

        if (email is String && password is String) {
          Map<String, String> loginData = {
            'EmailID': email,
            'password': password,
          };
          storedLoginIdPasswords.add(loginData);
        }
      }
    }

    controller.storedLoginIdPasswords = storedLoginIdPasswords;
  }

  @override
  Widget build(BuildContext context) {
    var registerformkey = GlobalKey<FormState>();
    // Initialize the controller

    double screenHeight = context.height;
    double screenWidth = context.width;

    return GetBuilder<LoginPageController>(builder: (_) {
      void passwordEye() {
        controller.registerobscureText = !controller.registerobscureText;
        controller.update();
      }

      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange,
          title: const Text(
            "Register page",
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
                child: const Text("Register",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              ),
              Form(
                key: registerformkey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      width: screenWidth - 20,
                      child: TextFormField(
                        controller: controller.registerpageemailcontrolller,
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
                        controller: controller.registerpagepasswordcontroller,
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
                                  controller.registerobscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black54,
                                ))),
                        obscureText: controller.registerobscureText,
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
                      width: screenWidth - 20,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.orange),
                          ),
                          onPressed: () async {
                            if (registerformkey.currentState!.validate()) {
                              if (controller.storedLoginIdPasswords.any((id) =>
                                  id['EmailID'] ==
                                  controller
                                      .registerpageemailcontrolller.text)) {
                                Get.closeAllSnackbars();
                                Get.snackbar('Already Exist',
                                    'Use another email address',
                                    snackPosition: SnackPosition.BOTTOM);
                              } else {
                                controller.storedLoginIdPasswords.add({
                                  'EmailID': controller
                                      .registerpageemailcontrolller.text,
                                  'password': controller
                                      .registerpagepasswordcontroller.text
                                });

                                box.put('IDPassword',
                                    controller.storedLoginIdPasswords);

                                Get.closeAllSnackbars();

                                Get.snackbar(
                                    duration: const Duration(seconds: 2),
                                    snackPosition: SnackPosition.BOTTOM,
                                    'Success',
                                    'Registered successfully');
                                Get.to(() => const LogininScreen());

                                controller.registerpageemailcontrolller.clear();
                                controller.registerpagepasswordcontroller
                                    .clear();
                                controller.update();
                              }

                            }
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(color: Colors.white),
                          )))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already Exist.? "),
                  GestureDetector(
                      onTap: () {
                        Get.to(() => const LogininScreen());
                        controller.registerpageemailcontrolller.clear();
                        controller.registerpagepasswordcontroller.clear();
                      },
                      child: const Text(
                        "login",
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
