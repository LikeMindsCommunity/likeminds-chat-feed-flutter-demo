import 'package:likeminds_flutter_sample/chat/service/media_service.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/views/media/document/document_preview.dart';

Widget documentPreviewFactory(List<Media> mediaList) {
  switch (mediaList.length) {
    case 1:
      return getSingleDocPreview(mediaList.first);
    case 2:
      return getDualDocPreview(mediaList);
    default:
      return GetMultipleDocPreview(mediaList: mediaList);
  }
}
