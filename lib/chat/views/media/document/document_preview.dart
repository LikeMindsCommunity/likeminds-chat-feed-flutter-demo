import 'package:likeminds_flutter_sample/chat/service/media_service.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/views/media/widget/document_tile.dart';

// ChatBubble for Single Document Attachment
Widget getSingleDocPreview(Media media) {
  return DocumentThumbnailFile(
    media: media,
  );
}

// ChatBubble for Two Document Attachment
Widget getDualDocPreview(List<Media> mediaList) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      DocumentTile(
        media: mediaList.first,
      ),
      DocumentTile(
        media: mediaList[1],
      )
    ],
  );
}

// ChatBubble for more than two Document Attachment

class GetMultipleDocPreview extends StatefulWidget {
  final List<Media> mediaList;
  const GetMultipleDocPreview({
    Key? key,
    required this.mediaList,
  }) : super(key: key);

  @override
  State<GetMultipleDocPreview> createState() => GgetMultipleDocPreviewState();
}

class GgetMultipleDocPreviewState extends State<GetMultipleDocPreview> {
  List<Media>? mediaList;
  ValueNotifier<bool> rebuildCurr = ValueNotifier<bool>(false);
  int length = 2;

  void onMoreButtonTap() {
    length = mediaList!.length;
    rebuildCurr.value = !rebuildCurr.value;
  }

  @override
  Widget build(BuildContext context) {
    mediaList = widget.mediaList;
    return ValueListenableBuilder(
      valueListenable: rebuildCurr,
      builder: (context, _, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: length,
              itemBuilder: (context, index) => DocumentTile(
                media: mediaList![index],
              ),
            ),
            mediaList!.length > 2 && mediaList!.length != length
                ? GestureDetector(
                    onTap: onMoreButtonTap,
                    behavior: HitTestBehavior.translucent,
                    child: SizedBox(
                      width: 60,
                      height: 15,
                      child: Text(
                        '+ ${mediaList!.length - 2} more',
                        style: LMTheme.medium.copyWith(
                            color: LMTheme.textLinkColor, fontSize: 9.sp),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
