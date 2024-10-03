import 'package:flutter/material.dart';
import 'package:login_page_package/widgets/loading.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:get/get.dart';
import 'controllers/signin_controller.dart';




class LoginPage extends StatefulWidget {
 const LoginPage({super.key});
 @override
 State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
 final signInController=Get.put(SigninController());


 @override
 Widget build(BuildContext context) {
  var screenHeight = MediaQuery.of(context).size.height;
  return Scaffold(
      backgroundColor: Colors.white,
      body:Obx(()=>
          LoadingOverlay(
           loadingMessage: 'Connecting...',
           isLoading: signInController.isLoading.value,
           child: SingleChildScrollView(
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 // SizedBox(height: screenHeight * 0.150),

                 Container(
                  width: double.infinity,
                  color:const Color(0xFFEFF8FF),
                  height: 300,
                  child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [


                    // Image.asset(
                    //  height:100,
                    //  width: 146,
                    //  'assets/logo.png',
                    // ),
                    Text('Clubits', style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),)


                   ],
                  ),
                 ),

                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
                  child: Column(
                   children: [
                    Align(
                     alignment: Alignment.centerLeft,
                     child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                       ),
                       SizedBox(
                        height: screenHeight * 0.008,
                       ),
                       const Text(
                        'Enter register Email-ID and password',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                       ),
                      ],
                     ),
                    ),
                    SizedBox(
                     height: screenHeight * 0.028,
                    ),
                    ReactiveForm(
                     formGroup: signInController.userNamePassForm.value,
                     child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       const  Text(
                        'Email',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                       ),
                       SizedBox(height: screenHeight * 0.006),
                       ReactiveTextField(
                        formControlName: 'Email',
                        textAlign: TextAlign.start,
                        style:const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                        decoration: InputDecoration(
                         suffixIcon:const Icon(Icons.person, color: Colors.black),
                         border: InputBorder.none,
                         filled: true,
                         fillColor: Colors.grey[200],
                         hintText: 'john@gmail.com',
                         contentPadding:
                         const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        ),
                        validationMessages: {
                         ValidationMessage.required: (error) => 'Email is required',
                         ValidationMessage.email: (error) => 'Invalid email format',
                        },
                       ),
                       SizedBox(height: screenHeight * 0.010),
                       const Text(
                        'Password',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                       ),
                       SizedBox(height: screenHeight * 0.006),
                       ReactiveTextField(
                        formControlName: 'Password',
                        obscureText: signInController.obscureText.value,
                        textAlign: TextAlign.start,
                        style:const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                        decoration: InputDecoration(
                         suffixIcon: IconButton(
                          icon: Icon(
                           signInController.obscureText.value
                               ? Icons.visibility_off
                               : Icons.visibility,
                           color: Colors.black,
                          ),
                          onPressed: () {
                           signInController.obscureText.value =
                           !signInController.obscureText.value;
                          },
                         ),
                         border: InputBorder.none,
                         filled: true,
                         fillColor: Colors.grey[200],
                         hintText: 'password',
                         contentPadding:
                         const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        ),
                        validationMessages: {
                         ValidationMessage.required: (error) => 'Password is required',
                         ValidationMessage.minLength: (error) =>
                         'The Password limit min 6 characters',
                        },
                       ),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         Row(
                          children: [
                           SizedBox(child: Checkbox(value: false, onChanged: (value) => null)),
                           const Text('Remember me')
                          ],
                         ),
                         const Text(
                          'Forgot Password?',
                          style: TextStyle(
                           decoration: TextDecoration.underline,
                           color: Colors.blue,
                           fontSize: 14,
                          ),
                         ),
                        ],
                       ),
                       SizedBox(height: screenHeight * 0.025),
                       Center(
                        child: ReactiveFormConsumer(
                         builder: (context, form, child) {
                          return SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: Obx(() => ElevatedButton(
                               onPressed: form.valid || signInController.isLoading.value
                                   ? () {
                                signInController.signIn();
                               }
                                   : null, // Disable button if form is not valid
                               style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    form.valid ? Colors.blue:Colors.blue),
                                shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                 RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                 ),
                                ),
                               ),
                               child:const  Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                               ),
                              ),
                              ));
                         },
                        ),
                       ),
                       SizedBox(height: screenHeight * 0.020),
                       const Center(
                           child: Text(
                            'Or',
                            style: TextStyle(fontWeight: FontWeight.bold),
                           )),
                       SizedBox(height: screenHeight * 0.010),
                       GestureDetector(
                        // onTap: () => Get.to(SignInEmailMobileView(SigninController)),
                        child: Container(
                         decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey),
                         ),
                         child:const Padding(
                          padding:  EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 5),
                          child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                            Text(
                             'Login with OTP',
                             style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),
                            ),
                           ],
                          ),
                         ),
                        ),
                       ),
                       SizedBox(height: screenHeight * 0.010),
                      ],
                     ),
                    ),
                   ],
                  ),
                 )

                ],
               )
           ),
          ),
      ));
 }
}