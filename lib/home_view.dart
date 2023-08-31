import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_flutter_sample/chat/likeminds_chat_mm_fl.dart';
import 'package:likeminds_flutter_sample/chat/utils/imports.dart';
import 'package:likeminds_flutter_sample/chat/views/home/bloc/home_bloc.dart';
import 'package:likeminds_flutter_sample/feed/likeminds_flutter_feed_sample.dart';
import 'package:likeminds_flutter_sample/feed/utils/constants/ui_constants.dart';

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
    _selectedIndex = 0;
  }

  @override
  void didUpdateWidget(covariant HomeView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _pages = <Widget>[widget.feed, widget.chat];
    _selectedIndex = 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped,
          selectedLabelStyle: TextStyle(color: userSelectedColor),
          selectedItemColor: userSelectedColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.feed_outlined),
              label: 'Feed',
              activeIcon: Icon(
                Icons.feed_outlined,
                color: userSelectedColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble),
              label: 'Chats',
              activeIcon: Icon(
                CupertinoIcons.chat_bubble,
                color: userSelectedColor,
              ),
            ),
          ],
        ),
        body: _pages.elementAt(_selectedIndex),
      ),
    );
  }
}
