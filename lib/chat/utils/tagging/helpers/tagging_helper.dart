// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';

import 'package:likeminds_flutter_sample/chat/utils/imports.dart';

class TaggingHelper {
  static final RegExp tagRegExp = RegExp(r'@([^<>~]+)~');
  static RegExp routeRegExp =
      RegExp(r'<<([^<>]+)\|route://([^<>]+)/([a-zA-Z-0-9]+)>>');
  static const String linkRoute =
      r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+';

  /// Encodes the string with the user tags and returns the encoded string
  static String encodeString(String string, List<UserTag> userTags) {
    final Iterable<RegExpMatch> matches = tagRegExp.allMatches(string);
    for (final match in matches) {
      final String tag = match.group(1)!;
      final UserTag? userTag =
          userTags.firstWhereOrNull((element) => element.name! == tag);
      if (userTag != null) {
        string = string.replaceAll(
            '@$tag~', '<<${userTag.name}|route://member/${userTag.id}>>');
      }
    }
    return string;
  }

  /// Decodes the string with the user tags and returns the decoded string
  static Map<String, String> decodeString(String string) {
    Map<String, String> result = {};
    final Iterable<RegExpMatch> matches = routeRegExp.allMatches(string);
    for (final match in matches) {
      final String tag = match.group(1)!;
      final String id = match.group(3)!;
      string = string.replaceAll('<<$tag|route://member/$id>>', '@$tag');
      result.addAll({'@$tag': id});
    }
    return result;
  }

  /// Matches the tags in the string and returns the list of matched tags
  static List<UserTag> matchTags(String text, List<UserTag> items) {
    final List<UserTag> tags = [];
    final Iterable<RegExpMatch> matches = tagRegExp.allMatches(text);
    for (final match in matches) {
      final String tag = match.group(1)!;
      final UserTag? userTag =
          items.firstWhereOrNull((element) => element.name! == tag);
      if (userTag != null) {
        tags.add(userTag);
      }
    }
    return tags;
  }

  static void routeToProfile(String userId) {
    debugPrint(userId);
  }

  /*
  * This function is used to convert the route to tag
  * Route '<<$tag|route://$mid/$id>>' is converted to tag '@$tag'
  */
  static String? convertRouteToTag(String? text, {bool withTilde = true}) {
    if (text == null) return null;
    final Iterable<RegExpMatch> matches = routeRegExp.allMatches(text);

    for (final match in matches) {
      final String tag = match.group(1)!;
      final String mid = match.group(2)!;
      final String id = match.group(3)!;
      text = text!.replaceAll(
          '<<$tag|route://$mid/$id>>', withTilde ? '@$tag~' : '@$tag');
    }
    return text;
  }

  /*
  * This function is used to convert the route to tag and user map
  * Route '<<$tag|route://$mid/$id>>' is converted to tag '@$tag'
  * and the user is added to the userTags list
  */
  static Map<String, dynamic> convertRouteToTagAndUserMap(String text,
      {bool withTilde = true}) {
    final Iterable<RegExpMatch> matches = routeRegExp.allMatches(text);
    List<UserTag> userTags = [];
    for (final match in matches) {
      final String tag = match.group(1)!;
      final String mid = match.group(2)!;
      final String id = match.group(3)!;
      text = text.replaceAll(
          '<<$tag|route://$mid/$id>>', withTilde ? '@$tag~' : '@$tag');
      userTags.add(UserTag(userUniqueId: id, name: tag));
    }
    return {'text': text, 'userTags': userTags};
  }

  /*
  * This function is used to convert a string containing the route to List<UserTag> 
  * Route '<<$tag|route://$mid/$id>>' is converted to tag '@$tag'
  * and the user is added to the userTags list
  */
  static List<UserTag> addUserTagsIfMatched(String input) {
    final Iterable<RegExpMatch> matches = routeRegExp.allMatches(input);
    List<UserTag> userTags = [];
    for (final match in matches) {
      final String tag = match.group(1)!;
      // final String mid = match.group(2)!;
      final String id = match.group(3)!;
      userTags.add(
        UserTag(
          userUniqueId: id,
          name: tag,
          id: int.tryParse(id),
        ),
      );
    }
    return userTags;
  }

  // This function is used to extract and convert state messages
  static String extractStateMessage(String input) {
    final RegExp stateRegex = RegExp(r"(?<=\<\<).+?(?=\|)");
    final RegExp tagRegex = RegExp(r"<<(?<=\<\<).+?(?=\>\>)>>");
    final Iterable<RegExpMatch> matches = tagRegex.allMatches(input);
    for (RegExpMatch match in matches) {
      final String? routeTag = match.group(0);
      final String? userName = stateRegex.firstMatch(routeTag!)?.group(0);
      input = input.replaceAll(routeTag, '$userName');
    }
    return input;
  }
}

// This function is used to extract links from a string
List<String> extractLinkFromString(String text) {
  RegExp exp = RegExp(TaggingHelper.linkRoute);
  Iterable<RegExpMatch> matches = exp.allMatches(text);
  List<String> links = [];
  for (var match in matches) {
    String link = text.substring(match.start, match.end);
    if (link.isNotEmpty) {
      links.add(link);
    }
  }
  if (links.isNotEmpty) {
    return links;
  } else {
    return [];
  }
}

// This function is used to extract the first valid link from a string
String getFirstValidLinkFromString(String text) {
  try {
    List<String> links = extractLinkFromString(text);
    List<String> validLinks = [];
    String validLink = '';
    if (links.isNotEmpty) {
      for (String link in links) {
        if (Uri.parse(link).isAbsolute) {
          validLinks.add(link);
        } else {
          link = "https://$link";
          if (Uri.parse(link).isAbsolute) {
            validLinks.add(link);
          }
        }
      }
    }
    if (validLinks.isNotEmpty) {
      validLink = validLinks.first;
    }
    return validLink;
  } catch (e) {
    return '';
  }
}
