import 'package:envied/envied.dart';

/// This file contains the credentials classes for the sample app.
/// You can use the default credentials provided by the Flutter Sample community.
/// Or you can create your own community and use the credentials from there.
/// To use your own community, create a file named [.env.dev] in the root directory
/// for beta credentials and [.env.prod] for production credentials.
/// Then run the following command to generate the credentials classes:
///   flutter pub run build_runner build
/// This will automatically generate the file [credentials.g.dart] in the same directory.

part 'fb_credentials.g.dart';

///These are BETA sample community credentials
@Envied(name: 'FBCredsDev', path: '.env.fb.dev')
abstract class FBCredsDev {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _FBCredsDev.apiKey;
  @EnviedField(varName: 'APP_ID', obfuscate: true)
  static final String appId = _FBCredsDev.appId;
  @EnviedField(varName: 'MESSAGING_SENDER_ID', obfuscate: true)
  static final String messagingSenderId = _FBCredsDev.messagingSenderId;
  @EnviedField(varName: 'PROJECT_ID', obfuscate: true)
  static final String projectId = _FBCredsDev.projectId;
  @EnviedField(varName: 'STORAGE_BUCKET', obfuscate: true)
  static final String storageBucket = _FBCredsDev.storageBucket;
  @EnviedField(varName: 'IOS_CLIENT_ID', obfuscate: true)
  static final String iosClientId = _FBCredsDev.iosClientId;
  @EnviedField(varName: 'IOS_BUNDLE_ID', obfuscate: true)
  static final String iosBundleId = _FBCredsDev.iosBundleId;
}

///These are PROD community credentials
@Envied(name: 'FBCredsProd', path: '.env.fb.prod')
abstract class FBCredsProd {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _FBCredsProd.apiKey;
  @EnviedField(varName: 'APP_ID', obfuscate: true)
  static final String appId = _FBCredsProd.appId;
  @EnviedField(varName: 'MESSAGING_SENDER_ID', obfuscate: true)
  static final String messagingSenderId = _FBCredsProd.messagingSenderId;
  @EnviedField(varName: 'PROJECT_ID', obfuscate: true)
  static final String projectId = _FBCredsProd.projectId;
  @EnviedField(varName: 'STORAGE_BUCKET', obfuscate: true)
  static final String storageBucket = _FBCredsProd.storageBucket;
  @EnviedField(varName: 'IOS_CLIENT_ID', obfuscate: true)
  static final String iosClientId = _FBCredsProd.iosClientId;
  @EnviedField(varName: 'IOS_BUNDLE_ID', obfuscate: true)
  static final String iosBundleId = _FBCredsProd.iosBundleId;
}
