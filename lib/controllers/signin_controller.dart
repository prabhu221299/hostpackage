import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';



class SigninController extends GetxController{

  final ApiService _apiService = ApiService();
  var isLoading=false.obs;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  var mobile = TextEditingController().obs;

  var obscureText = true.obs;
  late ReceivePort receivePort;
  Isolate? isolate;
  var pin="".obs;
  var remainingSeconds = 90.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    startIsolate();
    super.onInit();
  }


  @override
  void onClose() {
    isolate?.kill(priority: Isolate.immediate);
    receivePort.close();
    super.onClose();
  }

  final  userNamePassForm= FormGroup({
    "Email": FormControl(validators:[Validators.required,Validators.email]),
    "Password": FormControl(validators:[Validators.required,Validators.minLength(6)])
  }).obs;


  final  mobileOtpForm= FormGroup({
    "Mobile": FormControl(validators:[Validators.required]),
  }).obs;


  Future<void> startIsolate() async {
    log("start Isolate");
    receivePort = ReceivePort();
    isolate = await Isolate.spawn(_timerIsolate, receivePort.sendPort);

    receivePort.listen((message) {
      if (message is int) {
        remainingSeconds.value = message;
        if (message == 0) {
          isolate?.kill(priority: Isolate.immediate);
        }
      }
    });
  }

  static void _timerIsolate(SendPort sendPort) {
    int counter = 90;
    Timer.periodic(Duration(seconds: 1), (timer) {
      counter--;
      sendPort.send(counter);
      if (counter == 0) {
        timer.cancel();
      }
    });
  }

  void signIn() async {
    log("SignIn called");
    Map<String, dynamic> body = userNamePassForm.value.value;
    isLoading.value = true;
    try {
      dynamic response = await _apiService.auth('https://dev-Helpdesk-backend-v3-d7fhg6fmewagggcv.southindia-01.azurewebsites.net/user/login', body,);
      print(response);
      if (response!=null) {
        var data=response['data']['data'][0];
        log("Response received: ${response.toString()}");
        // UserModel newUser = UserModel(userID: data['UserID'], roleID: data['RoleID'], roleName: data['RoleName'], name: data['Username'], patientId: data['Username']);
        // await StorageServices.write('userInfo', newUser);

        isLoading.value = false;
        Get.snackbar(
          'Information!',
          'User Authenticated Successfully :)',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Color(0xFFD3F8DF),
          colorText: Colors.black,
        );
        dynamic result = response['data'];
        // Get.to(const Home());
      } else {
        isLoading.value = false;
        // Get.off(const Home());
        // Get.snackbar(
        //   'Error',
        //   'Failed to Authenticate. Please check your credentials.',
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );
      }
    } catch (e) {
      isLoading.value = false;
      // Get.off(const Home());
    }
  }




  void  signInWithEmailOtp(signInController) async {
    // isLoading.value = true;
    Map<String, dynamic> body = {
      "otpCredentials": mobileOtpForm.value.value['Mobile'].toString()
    };
    // Map<String, dynamic> body = userNamePassForm.value.value;


    // Get.to(OtpScreen(signInController));
    log(body.toString());
    // isLoading.value=true;
    try {
      dynamic response = await _apiService.auth('https://dev-Helpdesk-backend-v3-d7fhg6fmewagggcv.southindia-01.azurewebsites.net/user/otpLogin', body);
      log(response.toString());
      if (response['status']==200) {
        log("inside");
        print(response.toString());
        Get.snackbar('Information!','${response['message']}', snackPosition: SnackPosition.TOP,backgroundColor: Color(0xFFD3F8DF), colorText: Colors.black);

      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Failed to Authenticate',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }  catch (e) {
      isLoading.value = false;
    }
  }



  void  verifyOtp() async {
    log("VerifyOTP");
    // String otp = _otpControllers?.map((controller) => controller.text).join();

    isLoading.value = true;
    Map<String, dynamic> body = {
      "otpCredentials": mobileOtpForm.value.value['Mobile'].toString(),
      "otp":pin.value.toString()
    };
    log(body.toString());
    try {
      dynamic response = await _apiService.auth('https://dev-Helpdesk-backend-v3-d7fhg6fmewagggcv.southindia-01.azurewebsites.net/user/verifyOtp', body);

      log(response.toString());
      if (response['status']==200 && response!=null) {
        dynamic result= response['data'];
        // Get.to(Home());
        Get.snackbar('Information!', 'Otp verified Successfully (:', snackPosition: SnackPosition.TOP, backgroundColor: Color(0xFFD3F8DF), colorText: Colors.black);
        isLoading.value=false;
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          '${response['message']}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }  catch (e) {
      isLoading.value = false;
    }
  }


  void  resentOtp(signInController) async {
    isLoading.value = true;
    Map<String, dynamic> body = {
      "otpCredentials":  mobileOtpForm.value.value['Mobile'].toString()
    };

    log(body.toString());
    try {
      dynamic response = await _apiService.auth('https://dev-Helpdesk-backend-v3-d7fhg6fmewagggcv.southindia-01.azurewebsites.net/user/otpLogin', body);
      log(response.toString());
      if (response['status']==200) {
        Get.snackbar('Information!','${response['message']}', snackPosition: SnackPosition.TOP,backgroundColor: Color(0xFFD3F8DF), colorText: Colors.black);
      } else {
        isLoading.value = false;
      }
    }  catch (e) {
      isLoading.value = false;
    }
  }

}