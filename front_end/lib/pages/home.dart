import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BlockCast News',
          style: TextStyle(
            letterSpacing: 2.0,
            fontFamily: 'Futura',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            "assets/DApp_icon_white.png",
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(26, 26, 36, 1),
      ),
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
      backgroundColor: const Color.fromRGBO(234, 228, 234, 1),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("New broadcast"),
        onPressed: () {},
      ),
      bottomNavigationBar: Container(
        height: 40.0,
        color: const Color.fromRGBO(26, 26, 36, 1),
      ),
    );
  }
}
