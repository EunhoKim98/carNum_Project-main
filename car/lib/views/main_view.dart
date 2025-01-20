import 'package:flutter/material.dart';
import 'package:car/views/car_search_screen.dart';
import 'package:car/views/search_history.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
   const MainPage({super.key});

   @override
   State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
   int _currentIndex = 0;
   final PageController _pageController = PageController();

   final List<Widget> _screens = [
      const CarSearchScreen(),
      const SearchHistory(),
   ];

   @override
   void dispose() {
      _pageController.dispose(); // PageController를 dispose합니다.
      super.dispose();
   }

   @override
   Widget build(BuildContext context) {
      SvgPicture svgIcon(String src, {Color? color}) {
         return SvgPicture.asset(
            src,
            height: 24,
            colorFilter: ColorFilter.mode(
                color ??
                    Theme.of(context).iconTheme.color!.withOpacity(
                        Theme.of(context).brightness == Brightness.dark ? 0.3 : 1),
                BlendMode.srcIn),
         );
      }

      return SafeArea(
         child: Scaffold(
            body: PageView(
               controller: _pageController,
               onPageChanged: (index) {
                  setState(() {
                     _currentIndex = index;
                  });
               },
               children: _screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
               currentIndex: _currentIndex,
               onTap: (index) {
                  _pageController.jumpToPage(index); // 페이지 전환
               },
               items: const [
                  BottomNavigationBarItem(
                     icon: Icon(
                        Icons.car_crash,
                        color: Colors.white,
                     ),
                     label: "침수차검색",
                  ),
                  BottomNavigationBarItem(
                     icon: Icon(Icons.settings),
                     label: "검색이력",
                  ),
               ],
               backgroundColor: const Color.fromARGB(255, 54, 52, 163),
               selectedItemColor: Colors.white, // 선택된 아이콘 및 텍스트 색상
               unselectedItemColor: Colors.white70, // 선택되지 않은 아이콘 및 텍스트 색상
            ),
         ),
      );
   }
}
