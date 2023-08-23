import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/menu/task/task_widget.dart';
import 'package:provider/provider.dart';

import '../provider/add_event_provider.dart';
import '../provider/theme_provider.dart';

class AddEventMenu extends StatefulWidget {
  const AddEventMenu({super.key});

  @override
  State<AddEventMenu> createState() => _AddEventMenuState();
}

class _AddEventMenuState extends State<AddEventMenu> {
  double currentPageValue = 0;
  final PageController pageController = PageController();
  final _formTaskKey = GlobalKey<FormState>();
  final _formNoteKey = GlobalKey<FormState>();

  @override
  void initState() {
    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AddEventProvider>(
        builder: (context, provider, snapshot) {
          return Scaffold(
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
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "Select Type",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          int selectedIndex = 0;
                          provider.setCurrentPage = selectedIndex.toDouble();
                          pageController.animateToPage(selectedIndex.toInt(),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                          _formTaskKey.currentState?.reset();
                          provider.resetWidget = [''];
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            // color: pageController.page == 0
                            //     ? Colors.red
                            //     : Colors.grey,
                            color: provider.currentPage == 0
                                ? Colors.red
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: 130,
                          height: 40,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.note_alt_outlined,
                                size: 30,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Note",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          int selectedIndex = 1;
                          provider.setCurrentPage = selectedIndex.toDouble();
                          pageController.animateToPage(selectedIndex.toInt(),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                          _formNoteKey.currentState?.reset();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            // color: pageController.page == 1
                            //     ? Colors.red
                            //     : Colors.grey,
                            color: provider.currentPage == 1
                                ? Colors.red
                                : Colors.grey,

                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: 130,
                          height: 40,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.task_outlined,
                                size: 30,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Task",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Form(
                            key: _formNoteKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      child: Text(
                                        "Title",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: "Add Title",
                                      ),
                                      // The validator receives the text that the user has entered.
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      child: Text(
                                        "Add Content",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: "Add Content",
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color:
                                                  Colors.blue), //<-- SEE HERE
                                        ),
                                      ),
                                      minLines: 20,
                                      maxLines: null,
                                      // The validator receives the text that the user has entered.
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Validate returns true if the form is valid, or false otherwise.
                                        if (_formNoteKey.currentState!
                                            .validate()) {
                                          // If the form is valid, display a snackbar. In the real world,
                                          // you'd often call a server or save the information in a database.
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Processing Data')),
                                          );
                                        }
                                      },
                                      child: const Text('Submit'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Form(
                            key: _formTaskKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      child: Text(
                                        "Title",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: "Add Title",
                                      ),
                                      // The validator receives the text that the user has entered.
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 80,
                                      child: Text(
                                        "Sub Title",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: "Add Sub Title (Optional)",
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      child: Text(
                                        "Description",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: "Add Description (Optional)",
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color:
                                                  Colors.blue), //<-- SEE HERE
                                        ),
                                      ),
                                      minLines: 5,
                                      maxLines: null,
                                      // The validator receives the text that the user has entered.
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Task",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: provider.taskList.length,
                                      itemBuilder: (context, index) {
                                        bool isLast = index ==
                                            provider.taskList.length - 1;
                                        return Column(
                                          children: [
                                            TaskWidget(
                                              key: UniqueKey(),
                                              initialValue:
                                                  provider.taskList[index],
                                              onChanged: (v) =>
                                                  provider.taskList[index] = v,
                                              timeInitialValue:
                                                  provider.timeTaskList[index],
                                              onTimeChange: (t) =>
                                                  provider.timeTaskList[index] =
                                                      t.toString(),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    isLast
                                                        ? provider.addWidget()
                                                        : provider.removeWidget(
                                                            index);
                                                  },
                                                  child: isLast
                                                      ? const Text('Add Task')
                                                      : const Text(
                                                          'Remove Task'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 20,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Validate returns true if the form is valid, or false otherwise.
                                        if (_formTaskKey.currentState!
                                            .validate()) {
                                          // If the form is valid, display a snackbar. In the real world,
                                          // you'd often call a server or save the information in a database.
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Processing Data')),
                                          );
                                        }
                                      },
                                      child: const Text('Submit'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
