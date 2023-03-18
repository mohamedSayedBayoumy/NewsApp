import 'package:news_app_clean_architecture/_authenticator/data/auth_remote_data_source/auth_remote_data.dart';
import 'package:news_app_clean_architecture/_authenticator/domain/auth_base_repository/auth_base_repository.dart';
import 'package:news_app_clean_architecture/_authenticator/domain/auth_entites/auth_entits.dart';

class AuthRepository extends AuthBaseRepository {
  final BaseRemoteData baseRemoteData;

  AuthRepository(this.baseRemoteData);

  @override
  Future<AuthModel> login(AuthParameters authParameters) async {
    return await baseRemoteData.remoteLogin(authParameters);
  }

  @override
  Future<AuthModel> register(AuthParameters authParameters) async {
    return await baseRemoteData.remoteRegister(authParameters);
  }

  @override
  Future<AuthModel> addPhoneNumber(AuthParameters authParameters) async {
    return await baseRemoteData.addPhoneNumber(authParameters);
  }
}
