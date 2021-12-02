import 'package:ti/commonutils/ti_utilities.dart';
import 'package:ti/commonutils/navigation_menue.dart';
import 'package:ti/screens/apphome_screen.dart';
import 'package:ti/screens/login_page.dart';
import 'package:flutter/material.dart';

class AppHome extends StatefulWidget {
  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _pageIndex = 0;
  PageController _pageController = PageController();

  List<Widget> tabPages = [
    AppHomePageForm(),
    LoginPageForm(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          NavigationMenue.onBackButtonPressed(context);
          return Future(() => false);
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.teal,
            title: const Text(
              'यातायात निरीक्षक (TI)',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Colors.grey[200],
          drawer: NavigationMenue.navigationdrawerForAppHome(context),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.teal,
            currentIndex: _pageIndex,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.white,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: onTabTapped,
            // this will be set when a  tab is tapped
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                //icon:  Icon(Icons.home),
                label: 'Home',
              ),
              if (TiUtilities.user == null)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_pin),
                  label: 'Login',
                ),
              if (TiUtilities.user != null)
                const BottomNavigationBarItem(
                  //icon:  Icon(Icons.person),
                  icon: Icon(Icons.power_settings_new),
                  label: 'Logout',
                ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.live_help),
                label: 'Helpdesk',
              )
            ],
          ),
          body: PageView(
            children: tabPages,
            onPageChanged: onPageChanged,
            controller: _pageController,
          ),
        ));
  }

  void onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    if (index == 2) {
      const url =
          'https://cms.indianrail.gov.in/cmsREPORT/JSPRWD/rpt/ContactUs.html';
      TiUtilities.launchURL(url);
    } else {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }
}
