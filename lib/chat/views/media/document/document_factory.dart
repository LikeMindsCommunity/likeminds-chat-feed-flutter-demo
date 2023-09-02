import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/navigation/router.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/service/media_service.dart';
import 'package:likeminds_flutter_sample/chat/utils/media/permission_handler.dart';
import 'package:likeminds_flutter_sample/chat/utils/tagging/helpers/tagging_helper.dart';
import 'package:likeminds_flutter_sample/chat/utils/tagging/tagging_textfield_ta.dart';
import 'package:likeminds_flutter_sample/chat/views/chatroom/bloc/chat_action_bloc/chat_action_bloc.dart';
import 'package:likeminds_flutter_sample/chat/views/media/widget/media_helper_widget.dart';
import 'package:path/path.dart';

class DocumentFactory extends StatefulWidget {
  final List<Media> mediaList;
  final int chatroomId;
  const DocumentFactory(
      {Key? key, required this.mediaList, required this.chatroomId})
      : super(key: key);

  @override
  State<DocumentFactory> createState() => _DocumentFactoryState();
}

class _DocumentFactoryState extends State<DocumentFactory> {
  List<Media>? mediaList;
  final TextEditingController _textEditingController = TextEditingController();
  CarouselController controller = CarouselController();
  FilePicker filePicker = FilePicker.platform;
  ValueNotifier<bool> rebuildCurr = ValueNotifier<bool>(false);
  List<UserTag> userTags = [];
  String? result;
  int currPosition = 0;
  ChatActionBloc? chatActionBloc;

  bool checkIfMultipleAttachments() {
    return mediaList!.length > 1;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    rebuildCurr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatActionBloc = BlocProvider.of<ChatActionBloc>(context);
    mediaList = widget.mediaList;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ValueListenableBuilder(
        valueListenable: rebuildCurr,
        builder: (context, _, __) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 100.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            getDocumentThumbnail(
                                mediaList![currPosition].mediaFile!),
                            verticalPaddingXLarge,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  width: 80.w,
                                  child: Text(
                                    basenameWithoutExtension(
                                        mediaList![currPosition]
                                            .mediaFile!
                                            .path),
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: LMTheme.medium.copyWith(
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                                verticalPaddingSmall,
                                getDocumentDetails(mediaList![currPosition]),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                clipBehavior: Clip.none,
                decoration: const BoxDecoration(
                  color: blackColor,
                  border: Border(
                    top: BorderSide(
                      color: greyColor,
                      width: 0.1,
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            if (await handlePermissions(3)) {
                              List<Media> pickedFiles =
                                  await pickDocumentFiles();
                              mediaList!.addAll(pickedFiles);
                              setState(() {});
                            }
                          },
                          child: SizedBox(
                            width: 10.w,
                            height: 10.w,
                            child: Icon(
                              Icons.insert_drive_file,
                              color: whiteColor,
                              size: 24.sp,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TaggingAheadTextField(
                            isDown: false,
                            chatroomId: widget.chatroomId,
                            style: LMTheme.regular.copyWith(color: whiteColor),
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
                            userTags =
                                TaggingHelper.matchTags(string, userTags);
                            result =
                                TaggingHelper.encodeString(string, userTags);
                            result = result?.trim();
                            chatActionBloc!.add(
                              PostMultiMediaConversation(
                                (PostConversationRequestBuilder()
                                      ..attachmentCount(mediaList!.length)
                                      ..chatroomId(widget.chatroomId)
                                      ..temporaryId(DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString())
                                      ..text(result!)
                                      ..hasFiles(true))
                                    .build(),
                                mediaList!,
                              ),
                            );
                          },
                          child: Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: whiteColor.withOpacity(0.2),
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
                              color: whiteColor,
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
                              itemCount: mediaList!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  currPosition = index;
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
                                  child: getDocumentThumbnail(
                                      mediaList![index].mediaFile!),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
