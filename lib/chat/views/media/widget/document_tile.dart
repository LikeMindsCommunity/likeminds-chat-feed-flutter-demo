import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:likeminds_flutter_sample/chat/service/media_service.dart';
import 'package:likeminds_flutter_sample/chat/utils/constants/asset_constants.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/views/media/media_utils.dart';
import 'package:likeminds_flutter_sample/chat/views/media/widget/document_shimmer.dart';
import 'package:path/path.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentThumbnailFile extends StatefulWidget {
  final int? index;
  final Media media;

  const DocumentThumbnailFile({
    Key? key,
    required this.media,
    this.index,
  }) : super(key: key);

  @override
  State<DocumentThumbnailFile> createState() => _DocumentThumbnailFileState();
}

class _DocumentThumbnailFileState extends State<DocumentThumbnailFile> {
  String? _fileName;
  final String _fileExtension = 'pdf';
  String? _fileSize;
  String? url;
  File? file;
  Future? loadedFile;
  Widget? documentFile;

  Future loadFile() async {
    url = widget.media.mediaUrl;
    if (widget.media.mediaFile != null) {
      file = widget.media.mediaFile;
      _fileName = basenameWithoutExtension(file!.path);
    } else {
      final String url = widget.media.mediaUrl!;
      _fileName = basenameWithoutExtension(url);
      file = await DefaultCacheManager().getSingleFile(url);
    }

    _fileSize = getFileSizeString(bytes: widget.media.size!);
    documentFile = PdfDocumentLoader.openFile(
      file!.path,
      pageNumber: 1,
      pageBuilder: (context, textureBuilder, pageSize) => SizedBox(
        child: Container(
          height: 140,
          width: 55.w,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(kBorderRadiusMedium),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.cover,
            child: textureBuilder(
                allowAntialiasingIOS: true,
                backgroundFill: true,
                size: Size(pageSize.width, pageSize.height)),
          ),
        ),
      ),
    );
    return file;
  }

  @override
  void initState() {
    super.initState();
    loadedFile = loadFile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadedFile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return InkWell(
            onTap: () async {
              if (widget.media.mediaUrl != null) {
                debugPrint(widget.media.mediaUrl);
                Uri fileUrl = Uri.parse(widget.media.mediaUrl!);
                launchUrl(fileUrl, mode: LaunchMode.externalApplication);
              } else {
                OpenFilex.open(file!.path);
              }
            },
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                SizedBox(
                  child: documentFile!,
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 70,
                    width: 55.w,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      border: Border.all(color: kGreyWebBGColor, width: 1),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(
                          kBorderRadiusMedium,
                        ),
                        bottomRight: Radius.circular(
                          kBorderRadiusMedium,
                        ),
                      ),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: kPaddingLarge),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          kAssetDocPDFIcon,
                          fit: BoxFit.contain,
                        ),
                        kHorizontalPaddingSmall,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  _fileName ?? '',
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 10.sp, color: kGrey2Color),
                                ),
                              ),
                              kVerticalPaddingSmall,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  widget.media.pageCount != null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            kHorizontalPaddingXSmall,
                                            Text(
                                              "${widget.media.pageCount!} ${widget.media.pageCount! > 1 ? "Pages" : "Page"}",
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 8.sp,
                                                  color: kGrey3Color),
                                            ),
                                            kHorizontalPaddingXSmall,
                                            Text(
                                              '·',
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 8.sp,
                                                  color: kGrey3Color),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  kHorizontalPaddingXSmall,
                                  Text(
                                    _fileSize!.toUpperCase(),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 8.sp, color: kGrey3Color),
                                  ),
                                  kHorizontalPaddingXSmall,
                                  Text(
                                    '·',
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 8.sp, color: kGrey3Color),
                                  ),
                                  kHorizontalPaddingXSmall,
                                  Text(
                                    _fileExtension.toUpperCase(),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 8.sp, color: kGrey3Color),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        kHorizontalPaddingXSmall,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return getDocumentTileShimmer();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class DocumentTile extends StatefulWidget {
  final Media media;

  const DocumentTile({
    super.key,
    required this.media,
  });

  @override
  State<DocumentTile> createState() => _DocumentTileState();
}

class _DocumentTileState extends State<DocumentTile> {
  String? _fileName;
  final String _fileExtension = 'pdf';
  String? _fileSize;
  File? file;
  Future? loadedFile;

  Future loadFile() async {
    File file;
    if (widget.media.mediaFile != null) {
      file = widget.media.mediaFile!;
    } else {
      final String url = widget.media.mediaUrl!;
      file = File(url);
    }
    _fileSize = getFileSizeString(bytes: widget.media.size!);
    _fileName = basenameWithoutExtension(file.path);
    return file;
  }

  @override
  void initState() {
    super.initState();
    loadedFile = loadFile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadedFile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return InkWell(
              onTap: () async {
                if (widget.media.mediaFile != null) {
                  OpenFilex.open(widget.media.mediaFile!.path);
                } else {
                  debugPrint(widget.media.mediaUrl);
                  Uri fileUrl = Uri.parse(widget.media.mediaUrl!);
                  launchUrl(fileUrl, mode: LaunchMode.externalApplication);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: kPaddingSmall),
                child: Container(
                  height: 70,
                  width: 60.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: kGreyWebBGColor, width: 1),
                    borderRadius: BorderRadius.circular(kBorderRadiusMedium),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: kPaddingLarge),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        kAssetDocPDFIcon,
                        fit: BoxFit.contain,
                      ),
                      kHorizontalPaddingSmall,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _fileName ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10.sp, color: kGrey2Color),
                            ),
                            kVerticalPaddingSmall,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                widget.media.pageCount != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          widget.media.pageCount == null
                                              ? const SizedBox()
                                              : kHorizontalPaddingXSmall,
                                          widget.media.pageCount == null
                                              ? const SizedBox()
                                              : Text(
                                                  "${widget.media.pageCount!} ${widget.media.pageCount! > 1 ? "Pages" : "Page"}",
                                                  style: TextStyle(
                                                      fontSize: 8.sp,
                                                      color: kGrey3Color),
                                                ),
                                          kHorizontalPaddingXSmall,
                                          Text(
                                            '·',
                                            style: TextStyle(
                                                fontSize: 8.sp,
                                                color: kGrey3Color),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                kHorizontalPaddingXSmall,
                                Text(
                                  _fileSize!.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 8.sp, color: kGrey3Color),
                                ),
                                kHorizontalPaddingXSmall,
                                Text(
                                  '·',
                                  style: TextStyle(
                                      fontSize: 8.sp, color: kGrey3Color),
                                ),
                                kHorizontalPaddingXSmall,
                                Text(
                                  _fileExtension.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 8.sp, color: kGrey3Color),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return getDocumentTileShimmer();
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
