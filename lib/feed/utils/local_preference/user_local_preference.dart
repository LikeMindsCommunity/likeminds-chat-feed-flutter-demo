import 'dart:convert';

import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalPreference {
  SharedPreferences? _sharedPreferences;

  static UserLocalPreference? _instance;
  static UserLocalPreference get instance =>
      _instance ??= UserLocalPreference._();

  UserLocalPreference._();

  // Keys for storing user data on local storage
  final String _userKey = 'LikeMindsFlutterUser';
  final String _memberStateKey = 'LikeMindsFlutterIsCm';
  final String _userId = 'LikeMindsFlutterUserId';
  final String _userName = 'LikeMindsFlutterUserName';
  final String _apiKey = 'LikeMindsFlutterApiKey';

  Future<void> initialize() async {
    if (_sharedPreferences != null) return;
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future storeAppColor(int hex) async {
    await _sharedPreferences!.setInt('appColor', hex);
  }

  Color fetchAppColor() {
    int? appColor = _sharedPreferences!.getInt('appColor');
    if (appColor == null) {
      return kPrimaryColor;
    } else {
      return Color(appColor);
    }
  }

  // This functions stores the user data on local storage
  // after calling initiate user API
  // It takes [User] as input
  Future<void> storeUserData(User user) async {
    UserEntity userEntity = user.toEntity();
    Map<String, dynamic> userData = userEntity.toJson();
    String userString = jsonEncode(userData);
    await _sharedPreferences!.setString(_userKey, userString);
  }

  // This function stores the user id on local storage
  // after calling initiate user API or if the user
  // changes it from the settings screen
  Future<void> storeUserId(String userId) async {
    await _sharedPreferences!.setString(_userId, userId);
  }

  // This function stores the user id on local storage
  // after calling initiate user API or if the user
  // changes it from the settings screen
  Future<void> storeUserName(String userName) async {
    await _sharedPreferences!.setString(_userName, userName);
  }

  // This function stores the member state on local storage
  // after calling member state API
  // It takes [bool] as input [CM or normal user]
  Future<void> storeMemberState(bool isCm) async {
    await _sharedPreferences!.setBool(_memberStateKey, isCm);
  }

  // This function stores the [MemberStateResponse] object on local storage
  // after calling member state API
  // It takes [MemberStateResponse] as input
  Future<void> storeMemberRights(MemberStateResponse response) async {
    final entity = response.toEntity();
    Map<String, dynamic> memberRights = entity.toJson();
    String memberRightsString = jsonEncode(memberRights);
    await storeMemberState(response.state == 1);
    await _sharedPreferences!.setString('memberRights', memberRightsString);
  }

  // This function stores the api key on local storage
  // It takes [String] as input
  Future<void> storeApiKey(String apiKey) async {
    await _sharedPreferences!.setString(_apiKey, apiKey);
  }

  Future<void> storeUserDataFromInitiateUserResponse(
      InitiateUserResponse response) async {
    await UserLocalPreference.instance
        .storeUserData(response.initiateUser!.user);
    await UserLocalPreference.instance
        .storeUserId(response.initiateUser!.user.sdkClientInfo!.userUniqueId);
    await UserLocalPreference.instance
        .storeUserName(response.initiateUser!.user.name);
  }

  Future<void> storeMemberRightsFromMemberStateResponse(
      MemberStateResponse response) async {
    if (response.success) {
      await UserLocalPreference.instance.storeMemberRights(response);
    }
  }

  // This function fetches the user data from local storage
  // and returns [User] object
  User fetchUserData() {
    String? userDataString = _sharedPreferences!.getString(_userKey);

    Map<String, dynamic> userData = jsonDecode(userDataString!);

    return User.fromEntity(UserEntity.fromJson(userData));
  }

  // This function fetches the user id from local storage
  // and returns [String]
  String? fetchUserId() {
    return _sharedPreferences!.getString(_userId);
  }

  // This function fetches the user name from local storage
  // and returns [String]
  String? fetchUserName() {
    return _sharedPreferences!.getString(_userName);
  }

  // This function fetches the member state from local storage
  // and returns [bool]
  // [true] for CM and [false] for normal user
  bool fetchMemberState() {
    return _sharedPreferences!.getBool(_memberStateKey)!;
  }

  // This function fetches the api key from local storage
  // and returns [String]
  String? fetchApiKey() {
    return _sharedPreferences!.getString(_apiKey);
  }

  // This function fetches the user member state data
  // object from local storage
  // and returns [MemberStateResponse] object
  MemberStateResponse fetchMemberRights() {
    Map<String, dynamic> memberRights =
        jsonDecode(_sharedPreferences!.getString('memberRights')!);
    return MemberStateResponse.fromJson(memberRights);
  }

  bool fetchMemberRight(int id) {
    MemberStateResponse memberStateResponse = fetchMemberRights();
    final memberRights = memberStateResponse.memberRights;
    if (memberRights == null) {
      return true;
    } else {
      final right = memberRights.where((element) => element.state == id);
      if (right.isEmpty) {
        return true;
      } else {
        return right.first.isSelected;
      }
    }
  }

  Future<void> clearLocalPrefs() async {
    await _sharedPreferences!.clear();
  }
}
