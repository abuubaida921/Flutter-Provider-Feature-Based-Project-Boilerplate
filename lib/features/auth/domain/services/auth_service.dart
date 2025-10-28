import '../repositories/auth_repository_interface.dart';
import 'auth_service_interface.dart';

class AuthService implements AuthServiceInterface{
  AuthRepoInterface authRepoInterface;
  AuthService({required this.authRepoInterface});

  @override
  Future login(String? userInput, String? password, String? type) {
    return authRepoInterface.login(userInput, password, type);
  }

  @override
  Future logout() {
    return authRepoInterface.logout();
  }

  @override
  Future registration(Map<String, dynamic> body) {
    return authRepoInterface.registration(body);
  }


  @override
  Future<void> saveUserEmailAndPassword(String userLogData) {
    return authRepoInterface.saveUserEmailAndPassword(userLogData);
  }

  @override
  Future setLanguageCode(String code) {
    return authRepoInterface.setLanguageCode(code);
  }

}