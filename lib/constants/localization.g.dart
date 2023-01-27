import 'package:get/get.dart';

class Localization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'login_form': 'Login Form',
          'login': 'Login',
          'email_address': 'Email Address',
          'password': 'Password',
        },
        'ar': {
          'login_form': 'نموذج تسجيل الدخول',
          'login': 'تسجيل الدخول',
          'email_address': 'عنوان البريد الإلكتروني',
          'password': 'كلمه السر',
        },
        'he': {
          'login_form': 'فورما سيفر',
          'login': 'تسجيل الدخول',
          'email_address': 'عنوان البريد الإلكتروني',
          'password': 'سيفر',
        },
      };
}
