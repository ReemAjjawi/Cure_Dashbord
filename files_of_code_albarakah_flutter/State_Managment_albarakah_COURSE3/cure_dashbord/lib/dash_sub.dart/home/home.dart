import 'package:flutter/material.dart';

import '../../core/resources/managers/colors_manager.dart';
import '../codes/presenation/view.dart';
import '../statistics/presenation/view.dart';
import '../subjects/presentation/view.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, this.currentIndex});
  int? currentIndex = 0;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onTap(int index) {
    setState(() {
      widget.currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.currentIndex ??= 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.currentIndex ?? 0,
        children: const <Widget>[
          ShowSubjects(),
          ShowCodes(),
          ShowStatistics(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: BottomNavigationBar(
          onTap: _onTap,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'مقررات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_sharp),
              label: 'أكواد',
              //   backgroundColor: Color.fromARGB(255, 73, 59, 59)
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'المستخدمين',
            ),
          ],
          currentIndex: widget.currentIndex ?? 0,
          selectedItemColor: Colors.white, // Color for selected item
          unselectedItemColor: Colors.white, // Color for unselected items

          backgroundColor: ColorsManager.secondaryColor,
        ),
      ),
    );
  }
}
