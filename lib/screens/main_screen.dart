import 'package:flutter/material.dart';

import 'home_screen.dart';

import 'video_screen.dart'; // Import VideoScreen

import 'account_screen.dart';

import 'market_screen.dart';

import 'notification_screen.dart';


class MainScreen extends StatefulWidget {

  const MainScreen({super.key});


  @override

  _MainScreenState createState() => _MainScreenState();

}


class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;


  final List<String> _videoAssets = [

    'assets/sample_video.mp4',

    'assets/sample_video.mp4',

    'assets/sample_video.mp4',

    'assets/sample_video.mp4',

  ];


// List of screens (you might need to modify this based on your logic)

  final List<Widget> _screens = [

    HomeScreen(),

// Modify this to use VideoScreen and pass a video asset

    const VideoScreen(videoAsset: 'assets/sample_video.mp4'),

    const AccountScreen(),

    const MarketScreen(),
    NotificationScreen()

  ];


// Custom function to change the active and inactive colors for the BottomNavigationBar

  Color _getIconColor(int index) {

    return _currentIndex == index ? Colors.blue : Colors.orange;

  }


  @override

  Widget build(BuildContext context) {

    return Scaffold(



      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _currentIndex,

        onTap: (index) {

          setState(() {

            _currentIndex = index;

            if (index == 1) { // If Video Screen is tapped, set the right video asset

// Use a sample asset or a dynamic asset depending on your logic

              _screens[1] = VideoScreen(videoAsset: _videoAssets[index]);

            }

          });

        },

        items: [

          BottomNavigationBarItem(

            icon: Icon(Icons.home, color: _getIconColor(0)),

            label: 'Trang chủ',

          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.video_library, color: _getIconColor(1)),

            label: 'Hướng dẫn',

          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.account_circle, color: _getIconColor(2)),

            label: 'Tài khoản',

          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.shopping_cart, color: _getIconColor(3)),

            label: 'Lịch trình',

          ),
          BottomNavigationBarItem(

            icon: Icon(Icons.notifications, color: _getIconColor(4)),

            label: 'Thông báo',

          ),

        ],

        type: BottomNavigationBarType.fixed,

        backgroundColor: Colors.white,

        selectedItemColor: Colors.blue,

        unselectedItemColor: Colors.orange,

        elevation: 10,

      ),

    );

  }

}