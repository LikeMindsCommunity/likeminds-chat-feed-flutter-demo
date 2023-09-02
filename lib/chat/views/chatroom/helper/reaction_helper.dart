import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_flutter_sample/chat/utils/branding/theme.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';

List<String> reactionEmojis = ['♥️', '😂', '😮', '😢', '😡', '👍'];

Widget getListOfReactions({required Function onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: reactionEmojis
            .map((e) => GestureDetector(
                  onTap: () => onTap(e),
                  child: Text(
                    e,
                    style: LMTheme.bold.copyWith(fontSize: 15.sp),
                  ),
                ))
            .toList() +
        [
          GestureDetector(
            onTap: () => onTap('Add'),
            child: Icon(
              Icons.add_reaction_outlined,
              size: 18.sp,
            ),
          )
        ],
  );
}

Map<String, List<Reaction>> convertListToMapReaction(List<Reaction> reaction) {
  Map<String, List<Reaction>> mappedReactions = {};
  mappedReactions = {'All': reaction};
  for (var element in reaction) {
    if (mappedReactions.containsKey(element.reaction)) {
      mappedReactions[element.reaction]?.add(element);
    } else {
      mappedReactions[element.reaction] = [element];
    }
  }
  return mappedReactions;
}
