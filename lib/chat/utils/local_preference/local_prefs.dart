import 'dart:convert';

import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalPreference {
  SharedPreferences? _sharedPreferences;

  static UserLocalPreference? _instance;
  static UserLocalPreference get instance =>
      _instance ??= UserLocalPreference._();

  UserLocalPreference._();

  Future initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /*
  * This function is used to store the user data in the shared preferences
  * It takes in a User object and converts it to a UserEntity object
  * and then converts it to a json string and stores it in the shared preferences
  */
  Future storeUserData(User user) async {
    UserEntity userEntity = user.toEntity();
    Map<String, dynamic> userData = userEntity.toJson();
    String userString = jsonEncode(userData);
    await _sharedPreferences!.setString("user", userString);
  }

  /*
  * This function is used to fetch the user data from the shared preferences
  * It fetches the json string from the shared preferences and converts it to
  * a UserEntity object and then converts it to a User object and returns it
  */
  User fetchUserData() {
    Map<String, dynamic> userData =
        jsonDecode(_sharedPreferences!.getString("user")!);
    return User.fromEntity(UserEntity.fromJson(userData));
  }

  /*
  * This function is used to store the community data in the shared preferences
  * It takes in a Community object and converts it to a CommunityEntity object
  * and then converts it to a json string and stores it in the shared preferences
  */
  Future storeCommunityData(Community community) async {
    Map<String, dynamic> communityData = {
      "community_id": community.id,
      "community_name": community.name
    };
    String communityString = jsonEncode(communityData);
    await _sharedPreferences!.setString('community', communityString);
  }

  /*
  * This function is used to fetch the community data from the shared preferences
  * It fetches the json string from the shared preferences and converts it to
  * a Map<String,dynamic> and returns it
  */
  Map<String, dynamic> fetchCommunityData() {
    Map<String, dynamic> communityData =
        jsonDecode(_sharedPreferences!.getString('community')!);
    return communityData;
  }

  /*
  * This function is used to store the MemberStateResponse data in the shared preferences
  * It takes in a MemberStateResponse object and converts it to a MemberStateResponseEntity object
  * and then converts it to a json string and stores it in the shared preferences
  */
  Future storeMemberRights(MemberStateResponse? response) async {
    if (response == null) {
      return;
    }
    final entity = response.toEntity();
    Map<String, dynamic> memberRights = entity.toJson();
    String memberRightsString = jsonEncode(memberRights);
    await _sharedPreferences!.setString('memberRights', memberRightsString);
  }

  /*
  * This function is used to fetch the MemberStateResponse data from the shared preferences
  * It fetches the json string from the shared preferences and converts it to
  * a MemberStateResponseEntity object and then converts it to a MemberStateResponse object and returns it
  */
  MemberStateResponse fetchMemberRights() {
    Map<String, dynamic> memberRights =
        jsonDecode(_sharedPreferences!.getString('memberRights')!);
    MemberStateResponseEntity memberStateResponseEntity =
        MemberStateResponseEntity.fromJson(memberRights);
    return MemberStateResponse.fromEntity(memberStateResponseEntity);
  }

  /*
  * This function is used to fetch the MemberStateResponse data from the shared preferences
  * It fetches the json string from the shared preferences and converts it to
  * a MemberStateResponseEntity object and then converts it to a MemberStateResponse object and returns 
  * a boolean stating if the current user has the rights to perform the action or not
  */
  bool fetchMemberRight(int id) {
    MemberStateResponse memberStateResponse = fetchMemberRights();
    final memberRights = memberStateResponse.memberRights;
    if (memberRights == null) {
      return false;
    } else {
      final right = memberRights.where((element) => element.state == id);
      if (right.isEmpty) {
        return false;
      } else {
        return right.first.isSelected;
      }
    }
  }
}
