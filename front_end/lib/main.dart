import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Blockchain Twitter.',
            style: TextStyle(
              letterSpacing: 2.0,
              fontFamily: 'Futura',
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
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
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Click me"),
          onPressed: () {},
        ),
      ),
    ));
