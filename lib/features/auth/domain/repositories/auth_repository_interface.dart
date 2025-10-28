import '../../../../data/model/api_response.dart';
import '../../../../interface/repo_interface.dart';

abstract class AuthRepoInterface<T> implements RepositoryInterface{

  Future<ApiResponse> registration(Map<String, dynamic> body);

  Future<ApiResponse> login(String? userInput, String? password, String? type);

  Future<ApiResponse> logout();

  Future<void> saveUserEmailAndPassword(String userData);

  Future<ApiResponse> setLanguageCode(String code);


}