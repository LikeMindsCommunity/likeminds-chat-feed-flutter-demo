import 'package:flutter/cupertino.dart';
import 'package:likeminds_flutter_sample/chat/likeminds_chat_mm_fl.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/feed/likeminds_flutter_feed_sample.dart';

class HomeView extends StatefulWidget {
  LMFeed feed;
  LMChat chat;
  HomeView({Key? key, required this.chat, required this.feed})
      : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  List<Widget> _pages = <Widget>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pages = <Widget>[widget.feed, widget.chat];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_outlined),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble),
            label: 'Chats',
          ),
        ],
      ),
      body: _pages.elementAt(_selectedIndex),
    );
  }
}
