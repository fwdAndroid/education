import 'package:flutter/material.dart';

class Chapter extends StatefulWidget {
  final List<String> imagePaths;
  final String title;

  const Chapter({super.key, required this.imagePaths, required this.title});

  @override
  State<Chapter> createState() => _ChapterState();
}

class _ChapterState extends State<Chapter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xffab77ff),
      ),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Image.asset(widget.imagePaths[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
