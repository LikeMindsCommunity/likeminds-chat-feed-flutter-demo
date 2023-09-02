import 'package:envied/envied.dart';

/// DO NOT MODIFY THIS FILE
/// This file contains the credentials for the media management system

part 'credentials.g.dart';

///These are BETA sample community credentials
@Envied(name: 'CredsDev', path: '.env.dev')
abstract class CredsDev {
  @EnviedField(varName: 'BUCKET_NAME', obfuscate: true)
  static final bucketName = _CredsDev.bucketName;
  @EnviedField(varName: 'POOL_ID', obfuscate: true)
  static final poolId = _CredsDev.poolId;
}

///These are PROD community credentials
@Envied(name: 'CredsProd', path: '.env.prod')
abstract class CredsProd {
  @EnviedField(varName: 'BUCKET_NAME', obfuscate: true)
  static final bucketName = _CredsProd.bucketName;
  @EnviedField(varName: 'POOL_ID', obfuscate: true)
  static final poolId = _CredsProd.poolId;
}
