import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(26, 26, 34, 1),
        title: const Text(
          'BlockCast News',
          style: TextStyle(
            letterSpacing: 2.0,
            fontFamily: 'FuturaHeavy',
            fontSize: 25,
            // fontWeight: FontWeight.w600,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/DApp_icon_white.png",
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromRGBO(42, 42, 46, 1),
      body: const Center(
        child: Text(
          'Hello, World!',
          style: TextStyle(
            fontSize: 20.0,
            letterSpacing: 2.0,
            fontFamily: 'Futura',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("New broadcast"),
        onPressed: () {},
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        color: const Color.fromRGBO(26, 26, 36, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.feed, color: Colors.white),
                Text('News', style: TextStyle(color: Colors.white)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.groups, color: Colors.white),
                Text('Favorites', style: TextStyle(color: Colors.white)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.settings, color: Colors.white),
                Text('Settings', style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
