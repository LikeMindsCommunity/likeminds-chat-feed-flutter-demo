import 'package:flutter/material.dart';
import 'package:likeminds_flutter_sample/chat/views/home/home_page.dart';
import 'package:likeminds_flutter_sample/feed/views/universal_feed_page.dart';

class HotRestartController extends StatefulWidget {
  final Widget child;

  const HotRestartController({super.key, required this.child});

  static performHotRestart(BuildContext context) {
    final _HotRestartControllerState? state =
        context.findAncestorStateOfType<_HotRestartControllerState>();
    state?.performHotRestart();
  }

  @override
  _HotRestartControllerState createState() => _HotRestartControllerState();
}

class _HotRestartControllerState extends State<HotRestartController> {
  Key key = UniqueKey();

  void performHotRestart() {
    setState(() {});
    HomePage.refreshHomePage(context);
    UniversalFeedScreen.clearAndUpdateUniversalFeed(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}
