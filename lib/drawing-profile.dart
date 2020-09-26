import 'package:doda/x.dart';
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
        [],
        drawing: widget.drawing,
      )),
    );
  }
}
