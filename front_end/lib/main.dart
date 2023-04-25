import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'TwiChain',
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
          backgroundColor: const Color.fromRGBO(34, 28, 34, 1),
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
          label: const Text("Click me"),
          onPressed: () {},
        ),
      ),
    ));
