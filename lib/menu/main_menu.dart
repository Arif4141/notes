import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/menu/add_event_menu.dart';
import 'package:notes/provider/animated_container_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../provider/theme_provider.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({
    Key? key,
  }) : super(key: key);

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
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(value: "This Week", child: Text("This Week")),
      DropdownMenuItem(value: "This Month", child: Text("This Month")),
      DropdownMenuItem(value: "This Year", child: Text("This Year")),
    ];
    return menuItems;
  }

  String selectedValue = "This Week";

  List<_PieData> pieData = [
    _PieData(
      'Jan',
      35,
    ),
    _PieData(
      '',
      65,
    ),
  ];

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
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddEventMenu(),
              ),
            );
          },
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Task To Do: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            DropdownButton<String>(
                                alignment: Alignment.center,
                                value: selectedValue,
                                elevation: 16,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                items: dropdownItems,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                }),
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
                                      color: Colors.grey,
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
                          child: SizedBox(
                            height: 20,
                            child: Center(
                              child: Text(
                                provider.expandC == false
                                    ? "Show More"
                                    : "Show Less",
                                style: const TextStyle(color: Colors.grey),
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
                      'All Task',
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
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 150.0,
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
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
                                                fontSize: 25),
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
                                      Text(
                                        'Sub Title',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    height: 20,
                                    thickness: 1,
                                    endIndent: 0,
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 65,
                                        width: 260,
                                        color: Colors.grey,
                                        child: Text(
                                          'Titl xgdsdgs seg segse se aejabewoa aqw aobwf afw akfn abnwflabnw wajbwfajbwfa wajwfbaobfwabwfe',
                                          style: TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                      ),
                                      Container(
                                        height: 65,
                                        width: 65,
                                        color: Colors.grey,
                                        child: Stack(
                                          children: [
                                            SfCircularChart(
                                              legend: Legend(isVisible: false),
                                              palette: const [
                                                Colors.blueAccent,
                                                Colors.white
                                              ],
                                              series: <DoughnutSeries<_PieData,
                                                  String>>[
                                                DoughnutSeries<_PieData,
                                                        String>(
                                                    animationDelay: 0.7,
                                                    radius: '120%',
                                                    innerRadius: '80%',
                                                    explode: false,
                                                    dataSource: pieData,
                                                    xValueMapper:
                                                        (_PieData data, _) =>
                                                            data.xData,
                                                    yValueMapper:
                                                        (_PieData data, _) =>
                                                            data.yData,
                                                    dataLabelSettings:
                                                        const DataLabelSettings(
                                                            isVisible: false)),
                                              ],
                                            ),
                                            Center(
                                              child: Text(
                                                "35%",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).animate().fadeIn(delay: 2.seconds, duration: .7.seconds),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData);
  final String xData;
  final num yData;
}
