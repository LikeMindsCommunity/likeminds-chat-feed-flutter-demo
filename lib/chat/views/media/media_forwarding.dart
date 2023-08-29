import 'package:carousel_slider/carousel_slider.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/navigation/router.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/service/media_service.dart';
import 'package:likeminds_flutter_sample/chat/utils/media/permission_handler.dart';
import 'package:likeminds_flutter_sample/chat/utils/tagging/helpers/tagging_helper.dart';
import 'package:likeminds_flutter_sample/chat/utils/tagging/tagging_textfield_ta.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/bloc/chat_action_bloc/chat_action_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/media/document/document_factory.dart';
import 'package:likeminds_flutter_sample/chat/views/media/media_utils.dart';
import 'package:likeminds_flutter_sample/chat/views/media/multimedia/video/chat_video_factory.dart';
import 'package:likeminds_flutter_sample/chat/views/media/widget/media_helper_widget.dart';
import 'package:video_player/video_player.dart';

class MediaForward extends StatefulWidget {
  final int chatroomId;
  final List<Media> media;
  const MediaForward({
    Key? key,
    required this.media,
    required this.chatroomId,
  }) : super(key: key);

  @override
  State<MediaForward> createState() => _MediaForwardState();
}

class _MediaForwardState extends State<MediaForward> {
  final TextEditingController _textEditingController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  List<Media> mediaList = [];
  int currPosition = 0;
  CarouselController controller = CarouselController();
  ValueNotifier<bool> rebuildCurr = ValueNotifier<bool>(false);
  ChatActionBloc? chatActionBloc;
  FlickManager? flickManager;

  List<UserTag> userTags = [];
  String? result;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();

    super.dispose();
  }

  bool checkIfMultipleAttachments() {
    return mediaList.length > 1;
  }

  @override
  Widget build(BuildContext context) {
    mediaList = widget.media;

    chatActionBloc = BlocProvider.of<ChatActionBloc>(context);
    return WillPopScope(
      onWillPop: () {
        router.pop();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: kBlackColor,
        appBar: AppBar(
          backgroundColor: kBlackColor,
          leading: IconButton(
            onPressed: () {
              router.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          elevation: 0,
        ),
        body: ValueListenableBuilder(
            valueListenable: rebuildCurr,
            builder: (context, _, __) {
              return getMediaPreview();
            }),
      ),
    );
  }

  void setupFlickManager() {
    if (mediaList[currPosition].mediaType == MediaType.photo) {
      return;
    } else if (mediaList[currPosition].mediaType == MediaType.video &&
        flickManager == null) {
      flickManager = FlickManager(
        videoPlayerController:
            VideoPlayerController.file(mediaList[currPosition].mediaFile!),
        autoPlay: true,
        onVideoEnd: () {
          flickManager?.flickVideoManager?.videoPlayerController!
              .setLooping(true);
        },
        autoInitialize: true,
      );
    }
  }

  Widget getMediaPreview() {
    if (mediaList.first.mediaType == MediaType.photo ||
        mediaList.first.mediaType == MediaType.video) {
      // Initialise Flick Manager in case the selected media is an video
      setupFlickManager();
      return Column(
        children: [
          Expanded(
            child: mediaList[currPosition].mediaType == MediaType.photo
                ? AspectRatio(
                    aspectRatio: mediaList[currPosition].width! /
                        mediaList[currPosition].height!,
                    child: Image.file(mediaList[currPosition].mediaFile!),
                  )
                : chatVideoFactory(mediaList[currPosition], flickManager!),
          ),
          Container(
            decoration: const BoxDecoration(
                color: kBlackColor,
                border: Border(
                  top: BorderSide(
                    color: kGreyColor,
                    width: 0.1,
                  ),
                )),
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        if (await handlePermissions(1)) {
                          List<Media> pickedVideoFiles = await pickMediaFiles();
                          if (pickedVideoFiles.isNotEmpty) {
                            if (mediaList.length + pickedVideoFiles.length >
                                10) {
                              Fluttertoast.showToast(
                                  msg: 'Only 10 attachments can be sent');
                              return;
                            }
                            for (Media media in pickedVideoFiles) {
                              if (getFileSizeInDouble(media.size!) > 100) {
                                Fluttertoast.showToast(
                                  msg: 'File size should be smaller than 100MB',
                                );
                                pickedVideoFiles.remove(media);
                              }
                            }
                            mediaList.addAll(pickedVideoFiles);
                          }
                          rebuildCurr.value = !rebuildCurr.value;
                        }
                      },
                      child: SizedBox(
                        width: 10.w,
                        height: 10.w,
                        child: Icon(
                          Icons.photo_library,
                          color: kWhiteColor,
                          size: 24.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TaggingAheadTextField(
                        isDown: false,
                        chatroomId: widget.chatroomId,
                        style: LMTheme.regular.copyWith(color: kWhiteColor),
                        onTagSelected: (tag) {
                          // print(tag);
                          userTags.add(tag);
                        },
                        onChange: (value) {
                          // print(value);
                        },
                        controller: _textEditingController,
                        focusNode: FocusNode(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        router.pop();
                        final string = _textEditingController.text;
                        userTags = TaggingHelper.matchTags(string, userTags);
                        result = TaggingHelper.encodeString(string, userTags);
                        result = result?.trim();
                        chatActionBloc!.add(
                          PostMultiMediaConversation(
                            (PostConversationRequestBuilder()
                                  ..attachmentCount(mediaList.length)
                                  ..chatroomId(widget.chatroomId)
                                  ..temporaryId(DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString())
                                  ..text(result!)
                                  ..hasFiles(true))
                                .build(),
                            mediaList,
                          ),
                        );
                      },
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kWhiteColor.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                          color: LMTheme.buttonColor,
                          borderRadius: BorderRadius.circular(
                            100.0,
                          ),
                        ),
                        child: Icon(
                          Icons.send,
                          color: kWhiteColor,
                          size: 24.sp,
                        ),
                      ),
                    )
                  ],
                ),
                checkIfMultipleAttachments()
                    ? SizedBox(
                        height: 15.w,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: mediaList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              currPosition = index;
                              if (mediaList[index].mediaType ==
                                  MediaType.video) {
                                if (flickManager == null) {
                                  flickManager = FlickManager(
                                    videoPlayerController:
                                        VideoPlayerController.file(
                                            mediaList[index].mediaFile!),
                                    autoPlay: true,
                                    onVideoEnd: () {
                                      flickManager?.flickVideoManager
                                          ?.videoPlayerController!
                                          .setLooping(true);
                                    },
                                    autoInitialize: true,
                                  );
                                } else {
                                  flickManager?.handleChangeVideo(
                                    VideoPlayerController.file(
                                        mediaList[index].mediaFile!),
                                  );
                                }
                              }
                              rebuildCurr.value = !rebuildCurr.value;
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 6.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  border: currPosition == index
                                      ? Border.all(
                                          color: LMTheme.buttonColor,
                                          width: 5.0)
                                      : null),
                              width: 15.w,
                              height: 15.w,
                              child: mediaList[index].mediaType ==
                                      MediaType.photo
                                  ? Image.file(
                                      mediaList[index].mediaFile!,
                                      fit: BoxFit.cover,
                                    )
                                  // check if thumbnail file is there in the media object
                                  // if not then get the thumbnail from the video file
                                  : mediaList[index].thumbnailFile != null
                                      ? Image.file(
                                          mediaList[index].thumbnailFile!,
                                          fit: BoxFit.cover,
                                        )
                                      : FutureBuilder(
                                          future: getVideoThumbnail(
                                              mediaList[index]),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return mediaShimmer();
                                            } else if (snapshot.data != null) {
                                              return Image.file(
                                                snapshot.data!,
                                                fit: BoxFit.cover,
                                              );
                                            } else {
                                              return SizedBox(
                                                child: Icon(
                                                  Icons.error,
                                                  color: LMTheme.buttonColor,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          )
        ],
      );
    } else if (mediaList.first.mediaType == MediaType.document) {
      return DocumentFactory(
        mediaList: mediaList,
        chatroomId: widget.chatroomId,
      );
    }
    return const SizedBox();
  }
}
