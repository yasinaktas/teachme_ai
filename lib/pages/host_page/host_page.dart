import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_strings.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/models/navigation_item.dart';
import 'package:teachme_ai/pages/drawer_page/drawer_content.dart';
import 'package:teachme_ai/pages/home_page/home_page.dart';
import 'package:teachme_ai/pages/host_page/widgets/add_button.dart';
import 'package:teachme_ai/pages/host_page/widgets/custom_bottom_navigation_bar.dart';
import 'package:teachme_ai/pages/public_courses_page/public_courses_page.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil("/auth", (route) => false);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(AppStrings.appName, style: AppStyles.textStylePageTitle),
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
        drawer: DrawerContent(),
        extendBody: true,
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).padding.bottom +
                AppDimensions.pagePadding,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.pagePadding,
          ),
          child: Row(
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
              const SizedBox(width: AppDimensions.pagePadding),
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
      ),
    );
  }
}
