import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/baswidgets/show_custom_snakbar_widget.dart';
import '../../../data/model/api_response.dart';
import '../../../data/model/response_model.dart';
import '../../../helper/api_checker.dart';
import '../../../main.dart';
import '../../splash/controllers/splash_controller.dart';
import '../../splash/domain/models/config_model.dart';
import '../domain/models/register_model.dart';
import '../domain/models/signup_model.dart';
import '../domain/models/user_log_data.dart';
import '../domain/services/auth_service_interface.dart';
import '../enums/from_page.dart';

class AuthController with ChangeNotifier {
  final AuthServiceInterface authServiceInterface;
  AuthController( {required this.authServiceInterface});

  int resendTime = 0;

  bool _isLoading = false;
  bool? _isRemember = false;
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  bool _isAcceptTerms = false;
  bool get isAcceptTerms => _isAcceptTerms;

  bool _isNumberLogin = false;
  bool get isNumberLogin => _isNumberLogin;

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  String? _loginErrorMessage = '';
  String? get loginErrorMessage => _loginErrorMessage;

  set setIsLoading(bool value)=> _isLoading = value;
  set setIsPhoneVerificationButtonLoading(bool value) => _isPhoneNumberVerificationButtonLoading = value;

  bool _resendButtonLoading = false;
  bool get resendButtonLoading => _resendButtonLoading;


  bool _sendToEmail = false;
  bool get sendToEmail => _sendToEmail;

  String? _verificationMsg = '';
  String? get verificationMessage => _verificationMsg;

  bool _isForgotPasswordLoading = false;
  bool get isForgotPasswordLoading => _isForgotPasswordLoading;
  set setForgetPasswordLoading(bool value) => _isForgotPasswordLoading = value;

  String countryDialCode = '+880';
  void setCountryCode( String countryCode, {bool notify = true}){
    countryDialCode  = countryCode;
    if(notify){
      notifyListeners();
    }
  }

  String? _verificationID = '';
  String? get verificationID => _verificationID;

  updateSelectedIndex(int index, {bool notify = true}){
    _selectedIndex = index;
    if(notify){
      notifyListeners();
    }

  }


  bool get isLoading => _isLoading;
  bool? get isRemember => _isRemember;

  void updateRemember() {
    _isRemember = !_isRemember!;
    notifyListeners();
  }


  Future registration(RegisterModel register, Function callback, ConfigModel config) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authServiceInterface.registration(register.toJson());

    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? tempToken = '', token = '';

      if (map.containsKey('temporary_token')) {
        tempToken = map["temporary_token"];
      } else if(map.containsKey('token')) {
        token = map["token"];
      }

      if(token != null && token.isNotEmpty){
        /// TODO Save User Token
        /// TODO Update Device Token
        /// TODO We Will Move to Dashboard Screen
      } else if (tempToken != null && tempToken.isNotEmpty) {
        String type;
        if(config.customerVerification?.firebase == 1){
          type = 'phone';
        }else if(config.customerVerification?.phone == 1){
          type = 'phone';
        }else{
          type = 'email';
        }
        /// TODO Send Verification Code
      }
      notifyListeners();
    }else{
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }



  Future logOut() async {
    ApiResponse apiResponse = await authServiceInterface.logout();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

    }
  }



  Future<ResponseModel>  login (String? userInput, String? password, String? type, FromPage? fromPage) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();

    String? verificationType = type;
    String? userInputData = userInput;

    ApiResponse apiResponse = await authServiceInterface.login(userInput, password, verificationType);


    ResponseModel responseModel;
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final ConfigModel config = Provider.of<SplashController>(Get.context!, listen: false).configModel!;
      /// TODO clear guest id
      Map map = apiResponse.response!.data;

      String? temporaryToken = '', token = '', email, phone;
      bool isPhoneVerified = false;
      bool isMailVerified = false;

      try{
        token = map["token"];
        temporaryToken = map["temporary_token"];
        email = map["email"];
        phone = map["phone"];
        isPhoneVerified = map["is_phone_verified"] ?? false;
        isMailVerified = map["is_email_verified"] ?? false;
      }catch(e){
        token = null;
        temporaryToken = null;
      }

      if(isPhoneVerified && !isMailVerified && config.customerVerification?.phone == 0 && config.customerVerification?.email == 1 && email != null) {
        verificationType = 'email';
        userInputData = email;
      }

      if(!isPhoneVerified && isMailVerified && config.customerVerification?.phone == 1 && config.customerVerification?.email == 0 && phone != null) {
        verificationType = 'phone';
        userInputData = phone;
      }


      if(!isPhoneVerified && !isMailVerified && config.customerVerification?.phone == 0 && config.customerVerification?.email == 1 && email != null) {
        verificationType = 'email';
        userInputData = email;
      }

      if(!isPhoneVerified && !isMailVerified && config.customerVerification?.phone == 1 && config.customerVerification?.email == 0 && phone != null) {
        verificationType = 'phone';
        userInputData = phone;
      }


      if(token != null && token.isNotEmpty) {
        /// TODO Save User Token
        /// TODO Update Device Token
      } else if (temporaryToken != null) {
        /// TODO Send Verification Code
      }

      responseModel = ResponseModel('verification', token != null);
      // callback(true, token, temporaryToken, message);
      notifyListeners();
    } else {
      notifyListeners();
       responseModel = ResponseModel(apiResponse.error, false);
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }








  // for phone verification
  bool _isPhoneNumberVerificationButtonLoading = false;
  bool get isPhoneNumberVerificationButtonLoading => _isPhoneNumberVerificationButtonLoading;
  String _email = '';
  String _phone = '';

  String get email => _email;
  String get phone => _phone;

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }
  updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }



  String _verificationCode = '';
  String get verificationCode => _verificationCode;
  bool _isEnableVerificationCode = false;
  bool get isEnableVerificationCode => _isEnableVerificationCode;

  updateVerificationCode(String query) {
    if (query.length == 6) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }




  void isSentToMail(bool value){
    _sendToEmail = value;
    notifyListeners();
  }


  void toggleTermsCheck() {
    _isAcceptTerms = !_isAcceptTerms;
    notifyListeners();
  }

  toggleIsNumberLogin ({bool? value, bool isUpdate = true}) {
    if(value == null) {
      _isNumberLogin = !_isNumberLogin;
    }else {
      _isNumberLogin = value;
    }

    if(isUpdate){
      notifyListeners();
    }
  }

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }


  void clearVerificationMessage() {
    _verificationMsg = '';
  }

  Future<void> setCurrentLanguage(String currentLanguage) async {
    ApiResponse apiResponse = await authServiceInterface.setLanguageCode(currentLanguage);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

    }
  }

  void saveUserEmailAndPassword(UserLogData userLogData) {
    authServiceInterface.saveUserEmailAndPassword(jsonEncode(userLogData.toJson()));
  }

}

