import 'package:clippy_flutter/diagonal.dart';
import 'package:flight_booking_sys/controller/scaffoldController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:loading_animations/loading_animations.dart';
import '../../constants/constantsVariables.dart';
import '../../controller/authController.dart';
import 'package:get/get.dart';

class RegisterationView extends StatelessWidget {
  RegisterationView({Key? key}) : super(key: key);
  final auth = AuthController.controller;

  @override
  Widget build(BuildContext context) {
    bootstrapGridParameters(gutterSize: 0);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ScaffoldController.controller.showAppbar.value = false;
    });
    return registerationFormBuilder(context);
    // return Container(
    //     color: Theme.of(context).backgroundColor, child: buildDesktop(context));
  }

  Widget registerationFormBuilder(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: BootstrapContainer(
        fluid: true,
        children: [
          BootstrapRow(
            children: [uppCoverBuilder(context), registerationForm(context)],
          ),
        ],
      ),
    );
  }

  BootstrapCol uppCoverBuilder(BuildContext context) {
    return BootstrapCol(
        sizes: "col-12",
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Diagonal(
                        clipHeight: 50,
                        child: Container(
                          child: Image.asset(
                            'assets/appcover.jpeg',
                            fit: BoxFit.fill,
                          ),
                          height: Get.height / 4,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            Positioned.fill(
              child: Align(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/icon_no_background.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  height: Get.height / 9,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    shape: BoxShape.circle,
                  ),
                ),
                alignment: Alignment.bottomCenter,
              ),
            )
          ],
        ));
  }

  /*

   \"first_name\": \"sunt\",
    \"last_name\": \"qui\",
    \"email\": \"sed\",
    \"user_name\": \"corrupti\",
    \"password\": \"minima\",
    \"phone_number\": \"cupiditate\",
    \"birth_day\": \"quis\"

  */
  /*
   \"user_name\": \"autem\",
    \"password\": \"delectus\"
  */
  BootstrapCol registerationForm(context) {
    return BootstrapCol(
        sizes: "col-12",
        child: Obx(() {
          return Padding(
            padding: EdgeInsets.all(15).copyWith(top: 40),
            child: Form(
              key: auth.registerationFormKey,
              child: BootstrapRow(
                children: [
                  BootstrapCol(
                      sizes: "col-12",
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child:
                              Text("سجل دخولك الأن وتمتع بكل مميزات التطبيق"),
                        ),
                      )),
                  if (auth.isRegisterForm.value)
                    BootstrapCol(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: buildBeautifulTextField(context, "الإسم الأول",
                          validator: (val) {
                        if (!auth.isRegisterForm.value) return null;
                        String _val = val ?? '';
                        if (_val.trim().length == 0) return "هذا الحقل مطلوب";
                        if (_val.length < 2)
                          return "يجب أن يكون الإسم أكثر من حرف";
                      }, controller: auth.firstName),
                    )),
                  if (auth.isRegisterForm.value)
                    BootstrapCol(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: buildBeautifulTextField(context, "اللقب",
                          validator: (val) {
                        if (!auth.isRegisterForm.value) return null;
                        String _val = val ?? '';
                        if (_val.trim().length == 0) return "هذا الحقل مطلوب";
                        if (_val.length < 2)
                          return "يجب أن يكون اللقب أكثر من حرف";
                      }, controller: auth.lastName),
                    )),
                  BootstrapCol(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: buildBeautifulTextField(context, "اسم المستخدم",
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp("([0-9a-zA-Z_.])+")),
                        ], validator: (val) {
                      String _val = val ?? '';
                      if (_val.trim().length == 0) return "هذا الحقل مطلوب";
                    }, controller: auth.username),
                  )),
                  if (auth.isRegisterForm.value)
                    BootstrapCol(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: buildBeautifulTextField(context, "رقم الهاتف",
                          maxLength: 11,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                          ], validator: (val) {
                        if (!auth.isRegisterForm.value) return null;
                        String _val = val ?? '';
                        if (_val.trim().length == 0) return "هذا الحقل مطلوب";
                        if (_val.trim().length < 11 ||
                            _val.trim().length > 11 ||
                            !RegExp('^(077||078||075)(?=[0-9]{8}\$)[0-9]+(?<![_.])\$')
                                .hasMatch(_val))
                          return "يجب أدخال رقم صالح ( مثال 07700459826 )\nيجب أن يبدأ بـ 077 , 078 , 075";
                      }, controller: auth.phoneNumber),
                    )),
                  if (auth.isRegisterForm.value)
                    BootstrapCol(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: buildBeautifulTextField(
                          context, "البريد الإلكتروني", validator: (val) {
                        if (!auth.isRegisterForm.value) return null;
                        String _val = val ?? '';
                        if (_val.trim().length != 0) {
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(_val))
                            return "البريد الإلكتروني غير صالح";
                        }
                      }, controller: auth.email),
                    )),
                  BootstrapCol(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: buildBeautifulTextField(context, "الرمز السري",
                        suffix: IconButton(
                            onPressed: () {
                              auth.isVisiblePassword.value =
                                  !auth.isVisiblePassword.value;
                            },
                            icon: auth.isVisiblePassword.value
                                ? Icon(Icons.visibility_outlined)
                                : Icon(Icons.visibility_off_outlined)),
                        validator: (val) {
                      String _val = val ?? '';
                      if (_val.trim().length == 0) return "هذا الحقل مطلوب";
                      if (_val.trim().length < 6 || _val.trim().length > 30)
                        return "يجب أن يكون الرمز اكثر من ٦ حرف أو رمز";
                    },
                        controller: auth.password,
                        obscureText: !auth.isVisiblePassword.value),
                  )),
                  if (auth.isRegisterForm.value)
                    BootstrapCol(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: auth.birthDateInvalid.value
                              ? Theme.of(context).errorColor
                              : null,
                          side: auth.birthDateInvalid.value
                              ? BorderSide(color: Theme.of(context).errorColor)
                              : null,
                        ),
                        onPressed: () async {
                          if (!auth.isRegisterForm.value) return null;
                          DateTime? birthDate =
                              await Get.dialog(DatePickerDialog(
                            initialDate:
                                DateTime.now().subtract(Duration(days: 10)),
                            firstDate: DateTime(1940),
                            lastDate: DateTime.now(),
                          ));
                          if (birthDate != null) {
                            auth.birthDate.value =
                                "${birthDate.year}-${birthDate.month}-${birthDate.day < 10 ? '0' : ''}${birthDate.day}";
                            auth.birthDateInvalid.value = false;
                          }
                          print(auth.birthDate.value);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Obx(() => Text(auth.birthDate.value == ""
                              ? "ضبط تاريخ ميلادك"
                              : "تاريخ ميلادك : ${auth.birthDate.value}")),
                        ),
                      ),
                    )),
                  BootstrapCol(
                      child: ElevatedButton(
                    onPressed: () {
                      if (auth.isLoading.value) return;
                      if (auth.birthDate.value == "" &&
                          auth.isRegisterForm.value) {
                        auth.birthDateInvalid.value = true;
                      } else {
                        auth.birthDateInvalid.value = false;
                      }
                      if (auth.registerationFormKey.currentState!.validate() &&
                          !auth.birthDateInvalid.value) {
                        auth.loginUser();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: auth.isLoading.value
                          ? LoadingBouncingLine.circle(
                              size: 25,
                            )
                          : Text(auth.isRegisterForm.value
                              ? "إنشاء حساب جديد"
                              : "تسجيل دخول"),
                    ),
                  )),
                ],
              ),
            ),
          );
        }));
  }
}
