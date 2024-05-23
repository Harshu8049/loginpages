import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  List storedLoginIdPasswords = <Map<String, String>>[].obs;
  var registerpageemailcontrolller = TextEditingController();
  var registerpagepasswordcontroller = TextEditingController();
  

  var loginpageemailcontrolller = TextEditingController();
  var loginpagepasswordcontroller = TextEditingController();
  bool loginobscureText = true;
  bool registerobscureText = true;
  List dataUser1 = <dynamic>['hello', 'hellouser1'].obs;
  List dataUser2 = <dynamic>['hello', 'hellouser2'].obs;
  List dataUser3 = <dynamic>['hello', 'heloouser3'].obs;
  List data = <dynamic>['hello', 'heloonewuser'].obs;
}
