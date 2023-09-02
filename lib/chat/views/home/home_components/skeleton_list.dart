import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/widgets/skeleton_chat_box.dart';

class SkeletonChatList extends StatelessWidget {
  const SkeletonChatList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade300,
          period: const Duration(seconds: 2),
          direction: ShimmerDirection.ltr,
          child: const SkeletonChatBox(),
        );
      },
    );
  }
}
