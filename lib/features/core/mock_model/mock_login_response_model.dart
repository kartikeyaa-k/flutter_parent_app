import 'package:parent_app/features/core/mock_model/mock_user_model.dart';

class MockLoginResponseModel {
  final MockUserModel userModel;
  final String authToken;
  MockLoginResponseModel({
    required this.userModel,
    required this.authToken,
  });
}
