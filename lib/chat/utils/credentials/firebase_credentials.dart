import 'package:envied/envied.dart';

/// DO NOT MODIFY THIS FILE
/// This file contains the credentials for the core firebase systems

part 'firebase_credentials.g.dart';

///These are BETA firebase credentials
@Envied(name: 'FbCredsDev', path: '.env.fb-dev')
abstract class FbCredsDev {
  @EnviedField(varName: 'FB_API_KEY', obfuscate: true)
  static final String fbApiKey = _FbCredsDev.fbApiKey;
  @EnviedField(varName: 'FB_APP_ID_AN', obfuscate: true)
  static final String fbAppIdAN = _FbCredsDev.fbAppIdAN;
  @EnviedField(varName: 'FB_APP_ID_IOS', obfuscate: true)
  static final String fbAppIdIOS = _FbCredsDev.fbAppIdIOS;
  @EnviedField(varName: 'FB_MESSAGING_SENDER_ID', obfuscate: true)
  static final String fbMessagingSenderId = _FbCredsDev.fbMessagingSenderId;
  @EnviedField(varName: 'FB_PROJECT_ID', obfuscate: true)
  static final String fbProjectId = _FbCredsDev.fbProjectId;
  @EnviedField(varName: 'FB_DATABASE_URL', obfuscate: true)
  static final String fbDatabaseUrl = _FbCredsDev.fbDatabaseUrl;
}

///These are PROD firebase credentials
@Envied(name: 'FbCredsProd', path: '.env.fb-prod')
abstract class FbCredsProd {
  @EnviedField(varName: 'FB_API_KEY', obfuscate: true)
  static final String fbApiKey = _FbCredsProd.fbApiKey;
  @EnviedField(varName: 'FB_APP_ID_AN', obfuscate: true)
  static final String fbAppIdAN = _FbCredsProd.fbAppIdAN;
  @EnviedField(varName: 'FB_APP_ID_IOS', obfuscate: true)
  static final String fbAppIdIOS = _FbCredsProd.fbAppIdIOS;
  @EnviedField(varName: 'FB_MESSAGING_SENDER_ID', obfuscate: true)
  static final String fbMessagingSenderId = _FbCredsProd.fbMessagingSenderId;
  @EnviedField(varName: 'FB_PROJECT_ID', obfuscate: true)
  static final String fbProjectId = _FbCredsProd.fbProjectId;
  @EnviedField(varName: 'FB_DATABASE_URL', obfuscate: true)
  static final String fbDatabaseUrl = _FbCredsProd.fbDatabaseUrl;
}
