import 'package:flutter_provider_feature_based_project_boilerplate/features/splash/domain/services/splash_service_interface.dart';

import '../repositories/splash_repository_interface.dart';

class SplashService implements SplashServiceInterface{
  SplashRepositoryInterface splashRepositoryInterface;

  SplashService({required this.splashRepositoryInterface});

  @override
  void disableIntro() {
    return splashRepositoryInterface.disableIntro();
  }

  @override
  Future getConfig() {
    return splashRepositoryInterface.getConfig();
  }

  @override
  String getCurrency() {
    return splashRepositoryInterface.getCurrency();
  }

  @override
  void initSharedData() {
    return splashRepositoryInterface.initSharedData();
  }

  @override
  void setCurrency(String currencyCode) {
    return splashRepositoryInterface.setCurrency(currencyCode);
  }

  @override
  bool? showIntro() {
    return splashRepositoryInterface.showIntro();
  }

}