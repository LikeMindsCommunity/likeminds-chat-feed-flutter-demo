import 'package:get_it/get_it.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';

import 'package:likeminds_flutter_sample/chat/service/likeminds_service.dart';

final GetIt locator = GetIt.instance;

/*
* This function is used to setup the chat SDK
* initialises the locator with the LikeMindsService
* with the given apiKey and lmCallBack 
*/
void setupChat({required String apiKey, LMSDKCallback? lmCallBack}) {
  locator.allowReassignment = true;
  // registers the LikeMindsService with the given apiKey and lmCallBack
  locator.registerSingleton(
      LikeMindsService(apiKey: apiKey, lmCallBack: lmCallBack));
}
