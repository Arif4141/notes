import 'dart:math';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/provider/animated_container_provider.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  final iconList = <IconData>[
    Icons.home,
    Icons.calendar_month_outlined,
    Icons.bar_chart,
    Icons.settings_outlined,
  ];
  var _bottomNavIndex = 0; //default index of a first screen
  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;

  @override
  void initState() {
    super.initState();

    // Ads

    // Bottom Nav Bar
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: const Color(0xFF373A36),
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(
      const Duration(seconds: 1),
      () => _fabAnimationController.forward(),
    );
    Future.delayed(
      const Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'TaskNotes',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
          actions: [
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color(0xFF071e26)
                    : Colors.white,
              ),
            ),
            Consumer<ThemeProvider>(
              builder: (context, provider, child) {
                return PopupMenuButton(
                  icon: Icon(
                    Icons.notifications_none,
                    color: Theme.of(context).brightness == Brightness.light
                        ? const Color(0xFF071e26)
                        : Colors.white,
                  ),
                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem<String>(
                        value: 'light',
                        child: Text("Light Mode"),
                      ),
                      PopupMenuItem<String>(
                        value: 'dark',
                        child: Text("Dark Mode"),
                      ),
                      PopupMenuItem<String>(
                        value: 'system',
                        child: Text("System"),
                      ),
                    ];
                  },
                  onSelected: (String? value) {
                    provider.changeTheme(value ?? 'system');
                  },
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFFFA400),
          child: const Icon(
            Icons.add,
            color: Color(0xFF373A36),
          ),
          onPressed: () {},
          //params
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? const Color(0xFFFFA400) : Colors.white;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconList[index],
                  size: 24,
                  color: color,
                ),
              ],
            );
          },
          height: 50,
          splashRadius: 0,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.smoothEdge,
          backgroundColor: const Color(0xFF373A36),
          notchAndCornersAnimation: borderRadiusAnimation,
          hideAnimationController: _hideBottomBarAnimationController,
          onTap: (index) => setState(() => _bottomNavIndex = index),
          //other params
        ),
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Consumer<AnimatedContainerProvider>(
                    builder: (context, provider, child) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF3b3b4d),
                          Color(0xFF272636),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Events",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Row(
                              children: [
                                const Text(
                                  '26/03/2023',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {},
                                  icon: const Icon(Icons.date_range),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          endIndent: 0,
                          color: Colors.grey,
                        ),
                        AnimatedContainer(
                            padding: const EdgeInsets.all(5),
                            height: Provider.of<AnimatedContainerProvider>(
                                    context,
                                    listen: true)
                                .value,
                            color: Colors.red,
                            duration: .3.seconds,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 5,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Container(
                                      color: Colors.green,
                                      height: 90,
                                    ),
                                  );
                                })),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (provider.expandC == false) {
                              provider.expandCont();
                            } else if (provider.expandC == true) {
                              provider.shrinkCont();
                            }
                          },
                          child: const SizedBox(
                            height: 20,
                            child: Center(
                              child: Text(
                                'Show all',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ).animate().fadeIn(delay: 1.seconds, duration: .7.seconds);
                }),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notes',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Show all',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1.5.seconds, duration: .7.seconds),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 3),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                width: 180,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Title',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          GestureDetector(
                                              onTap: () {},
                                              child: const Icon(
                                                Icons.open_in_new,
                                                size: 20,
                                              ))
                                        ],
                                      ),
                                      const Divider(
                                        height: 20,
                                        thickness: 1,
                                        endIndent: 0,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        'Titl xgdsdgs seg segse se aejabewoa aqw aobwf afw akfn abnwflabnw wajbwfajbwfa wajwfbaobfwabwfe',
                                        style: TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                      .animate()
                      .fadeIn(delay: 1.5.seconds, duration: .7.seconds),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Task',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Show all',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 2.seconds, duration: .7.seconds),
                const SizedBox(
                  height: 20,
                ),
                MasonryGridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                  itemBuilder: (contex, index) {
                    Random rnd;
                    int min = 150;
                    int max = 350;
                    rnd = Random();
                    int r = min + rnd.nextInt(max - min);
                    double h = r.toDouble();

                    return Container(
                      height: h,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //
                          // Contents
                          //
                        ],
                      ),
                    );
                  },
                ).animate().fadeIn(delay: 2.seconds, duration: .7.seconds),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
