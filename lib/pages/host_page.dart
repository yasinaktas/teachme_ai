import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_strings.dart';
import 'package:teachme_ai/models/navigation_item.dart';
import 'package:teachme_ai/pages/home_page.dart';
import 'package:teachme_ai/pages/public_courses_page.dart';
import 'package:teachme_ai/widgets/add_button.dart';
import 'package:teachme_ai/widgets/custom_bottom_navigation_bar.dart';

class HostPage extends StatefulWidget {
  const HostPage({super.key});

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  int _selectedIndex = 0;
  final List<NavigationItem> _navigationItems = [
    NavigationItem(iconData: Icons.home, label: "Home", page: HomePage()),
    NavigationItem(
      iconData: Icons.search,
      label: "All Courses",
      page: PublicCoursesPage(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.appName,
          style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/profile");
            },
            icon: CircleAvatar(
              backgroundColor: AppColors.secondarySurfaceColor,
              child: Icon(Icons.person, color: AppColors.secondaryColor),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.only(right: 8.0),
      ),
      drawer: Drawer(backgroundColor: AppColors.backgroundColor),
      extendBody: true,
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              child: SizedBox(
                height: 60,
                child: CustomBottomNavigationBar(
                  items: _navigationItems,
                  selectedIndex: _selectedIndex,
                  onItemSelected: (value) {
                    setState(() {
                      _selectedIndex = value;
                    });
                  },
                ),
              ),
            ),
            AddButton(
              onPressed: () {
                Navigator.pushNamed(context, "/addCourse");
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _navigationItems.map((item) => item.page).toList(),
      ),
    );
  }
}
