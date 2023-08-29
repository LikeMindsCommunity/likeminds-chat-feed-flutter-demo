import 'dart:io';
import 'package:likeminds_flutter_sample/chat/utils/constants/string_constants.dart';
import 'package:likeminds_flutter_sample/chat/utils/credentials/credentials.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';

import 'package:simple_s3/simple_s3.dart';

enum MediaType { photo, video, document, audio, gif, voiceNote }

String mapMediaTypeToString(MediaType mediaType) {
  switch (mediaType) {
    case MediaType.photo:
      return kAttachmentTypeImage;
    case MediaType.video:
      return kAttachmentTypeVideo;
    case MediaType.document:
      return kAttachmentTypePDF;
    case MediaType.audio:
      return kAttachmentTypeAudio;
    case MediaType.gif:
      return kAttachmentTypeGIF;
    case MediaType.voiceNote:
      return kAttachmentTypeVoiceNote;
    default:
      return kAttachmentTypeImage;
  }
}

MediaType mapStringToMediaType(String mediaType) {
  switch (mediaType) {
    case kAttachmentTypeImage:
      return MediaType.photo;
    case kAttachmentTypeVideo:
      return MediaType.video;
    case kAttachmentTypePDF:
      return MediaType.document;
    case kAttachmentTypeAudio:
      return MediaType.audio;
    case kAttachmentTypeGIF:
      return MediaType.gif;
    case kAttachmentTypeVoiceNote:
      return MediaType.voiceNote;
    default:
      return MediaType.photo;
  }
}

class Media {
  File? mediaFile;
  MediaType mediaType;
  String? mediaUrl;
  int? width;
  int? height;
  String? thumbnailUrl;
  File? thumbnailFile;
  int? pageCount;
  int? size; // In bytes

  Media({
    this.mediaFile,
    required this.mediaType,
    this.mediaUrl,
    this.height,
    this.pageCount,
    this.size,
    this.thumbnailFile,
    this.thumbnailUrl,
    this.width,
  });

  static Media fromJson(dynamic json) => Media(
        mediaType: mapStringToMediaType(json['type']),
        height: json['height'] as int?,
        mediaUrl: json['url'] ?? json['file_url'],
        size: json['meta']['size'],
        width: json['width'] as int?,
        thumbnailUrl: json['thumbnail_url'] as String?,
        pageCount: json['meta']['number_of_page'] as int?,
      );
}

class MediaService {
  late final String _bucketName;
  late final String _poolId;
  final _region = AWSRegions.apSouth1;
  final SimpleS3 _s3Client = SimpleS3();

  MediaService(bool isProd) {
    _bucketName = isProd ? CredsProd.bucketName : CredsDev.bucketName;
    _poolId = isProd ? CredsProd.poolId : CredsDev.poolId;
  }

  Future<String?> uploadFile(
    File file,
    int chatroomId,
    int conversationId,
  ) async {
    try {
      String result = await _s3Client.uploadFile(
        file,
        _bucketName,
        _poolId,
        _region,
        s3FolderPath:
            "files/collabcard/$chatroomId/conversation/$conversationId/",
      );
      return result;
    } on SimpleS3Errors catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
