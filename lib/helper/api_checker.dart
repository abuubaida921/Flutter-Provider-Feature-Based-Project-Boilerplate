import 'dart:developer';
import 'package:provider/provider.dart';

import '../common/baswidgets/show_custom_snakbar_widget.dart';
import '../data/model/api_response.dart';
import '../data/model/error_response.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../main.dart';

class ApiChecker {
  static void checkApi(ApiResponse apiResponse, {bool firebaseResponse = false}) {

    dynamic errorResponse = apiResponse.error is String ? apiResponse.error :  ErrorResponse.fromJson(apiResponse.error);
    if(apiResponse.error == "Failed to load data - status code: 401") {
      // Provider.of<AuthController>(Get.context!,listen: false).clearSharedData();
    }else if(apiResponse.response?.statusCode == 500){
      showCustomSnackBar('Internal Server Error', Get.context!);
    }else if(apiResponse.response?.statusCode == 503){
      showCustomSnackBar(apiResponse.response?.data['message'] , Get.context!);
    }else {
      log("==ff=>${apiResponse.error}");
      String? errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        log(errorResponse.toString());
      }
      showCustomSnackBar(firebaseResponse ? errorResponse?.replaceAll('_', ' ') : errorMessage, Get.context!);
    }
  }


  static ErrorResponse getError(ApiResponse apiResponse){
    ErrorResponse error;

    try{
      error = ErrorResponse.fromJson(apiResponse.response?.data);
    }catch(e){
      if(apiResponse.error is String){
        error = ErrorResponse(errors: [Errors(code: '', message: apiResponse.error.toString())]);

      }else{
        error = ErrorResponse.fromJson(apiResponse.error);
      }
    }
    return error;
  }
}