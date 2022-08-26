import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:okolicznie/screens/board_screen.dart';
import 'package:okolicznie/screens/user_chats_screen.dart';
import 'package:provider/provider.dart';
import '../helpers/db_helper.dart';
import '../providers/chats.dart';

class HomeScreen extends StatefulWidget {
  static final route = '/home';
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  final ValueNotifier<int> index = ValueNotifier(1);
  final ValueNotifier<String> title =
      ValueNotifier('Zwierzakowe sprawy w okolicy');
  // int index = 1;
  List<Widget> screens = [
    UserChatsScreen(),
    EventsListScreen(),
    Center(child: Text("profil")),
    Center(
      child: Container(
        child: Center(
          child: TextButton(
            onPressed: () async {
              await DBhelper.logout();
            },
            child: Text("wyloguj"),
          ),
        ),
      ),
    )
  ];

  final screenTitles = [
    'Wiadomosci',
    'Zwierzakowe sprawy w okolicy',
    'Moj Profil',
    'Ustawienia'
  ];
  @override
  Widget build(BuildContext context) {
    index.addListener(
      () => print(index.value),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Chats(),
          lazy: true,
        ),
      ],
      builder: (context, child) => Scaffold(
        appBar: _AppBar(),
        bottomNavigationBar: BottomNavBar(
          onItemSelected: (value) {
            index.value = value;
            title.value = screenTitles[value];
            // setState(() {
            //   index = value;
            //   print(index);
            // });
          },
          
        ),
        extendBody: true,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ValueListenableBuilder(
            valueListenable: index,
            builder: (context, int value, _) {
              return screens[value];
            },
          ),
        ),
      ),
    );
  }

  AppBar _AppBar() {
    return AppBar(
      actions: [],
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      elevation: 0,
      title: ValueListenableBuilder(
          valueListenable: title,
          builder: (context, String value, child) => Center(
                child: Text(
                  value,
                  style: TextStyle(
                    color: Color.fromARGB(255, 47, 115, 100),
                    fontWeight: FontWeight.w100
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key? key, required this.onItemSelected}) : super(key: key);
  final ValueChanged<int> onItemSelected;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  void didChangeDependencies() {
    // unreadMessages= context.watch<Chats>().unread;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  late String unreadMessages;
  int selectedIndex = 1;
  void onItemSelected(int index) {
    widget.onItemSelected(index);
    selectedIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String? unread = context.watch<Chats>().unreadS;
    return SafeArea(
      
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(0, 255, 255, 255),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
          Badge(
            position: BadgePosition(start: 10, top: -8),
            badgeColor: Color.fromARGB(255, 232, 69, 69),
            padding: EdgeInsets.all(8),
            elevation: 10,
            showBadge: unread != '0' ? true : false,
            badgeContent: Text(
              unread ?? "as",
              style: TextStyle(color: Colors.white),
            ),
            alignment: Alignment.centerLeft,
            child: _NavBarItem(
              icon: CupertinoIcons.bubble_left_bubble_right_fill,
              label: "Wiadomosci",
              index: 0,
              onTap: onItemSelected,
              isSelected: (selectedIndex == 0),
            ),
          ),
          _NavBarItem(
            icon: CupertinoIcons.square_list_fill,
            label: "Zwierzakowe sprawy",
            index: 1,
            onTap: onItemSelected,
            isSelected: selectedIndex == 1,
          ),
          _NavBarItem(
            icon: CupertinoIcons.profile_circled,
            label: "Moj profil",
            index: 2,
            onTap: onItemSelected,
            isSelected: selectedIndex == 2,
          ),
          _NavBarItem(
            icon: CupertinoIcons.settings,
            label: "Ustawienia",
            index: 3,
            onTap: onItemSelected,
            isSelected: selectedIndex == 3,
          ),
      ],
    ),
        ));
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    Key? key,
    required this.label,
    required this.icon,
    required this.index,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);
  final String label;
  final IconData icon;
  final int index;
  final ValueChanged<int> onTap;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                color: isSelected
                    ? Color.fromARGB(153, 47, 115, 100)
                    : Color.fromARGB(83, 0, 0, 0),
                icon,
                size: 40,
              ),
              // Text(
              //   label,
              //   style: TextStyle(
              //       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
