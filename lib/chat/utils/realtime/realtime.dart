import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:likeminds_flutter_sample/chat/utils/local_preference/local_prefs.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';

class LMRealtime {
  static LMRealtime? _instance;
  static LMRealtime get instance => _instance ??= LMRealtime._internal();

  late final FirebaseDatabase database;
  final int _communityId =
      UserLocalPreference.instance.fetchCommunityData()["community_id"];
  int? _chatroomId;

  LMRealtime._internal() {
    debugPrint('LMRealtime initialized');
    FirebaseApp app = Firebase.app('likeminds_chat');
    database = FirebaseDatabase.instanceFor(app: app);
    debugPrint("BETA database is ${database.databaseURL}");
  }

  set chatroomId(int chatroomId) {
    _chatroomId = chatroomId;
  }

  DatabaseReference homeFeed() {
    return database.ref().child("community").child(_communityId.toString()).ref;
  }

  DatabaseReference chatroom() {
    return database.ref().child("collabcards").child("$_chatroomId").ref;
  }
}
