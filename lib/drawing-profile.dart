import 'package:doda/discussion-board.dart';
import 'package:flutter/material.dart';

class DrawingProfile extends StatefulWidget {
  final Map<String, dynamic> drawing;
  DrawingProfile({@required this.drawing});
  @override
  _DrawingProfileState createState() => _DrawingProfileState();
}

class _DrawingProfileState extends State<DrawingProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
          child: ImageWithOverlays(
        [Offset(22, 16)],
        drawing: widget.drawing,
      )),
    );
  }
}
