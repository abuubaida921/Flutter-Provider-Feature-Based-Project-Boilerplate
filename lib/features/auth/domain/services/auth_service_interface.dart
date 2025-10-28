abstract class AuthServiceInterface{

  Future<dynamic> registration(Map<String, dynamic> body, );

  Future<dynamic> login(String? userInput, String? password, String? type);

  Future<dynamic> logout();

  Future<dynamic> setLanguageCode(String token);

  Future<void> saveUserEmailAndPassword(String userData);
}