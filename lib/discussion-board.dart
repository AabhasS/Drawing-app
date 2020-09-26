import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;

class ImageWithOverlays extends StatefulWidget {
  final Map<String, dynamic> drawing;
  final List<Offset> fractionalOffsets;
  ImageWithOverlays(this.fractionalOffsets, {this.drawing});

  @override
  _ImageWithOverlaysState createState() => _ImageWithOverlaysState();
}

class _ImageWithOverlaysState extends State<ImageWithOverlays> {
  Offset _startingFocalPoint;
  Offset _previousOffset;
  Offset _offset = Offset.zero;

  double _previousZoom;
  double _zoom = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onScaleStart: _handleScaleStart,
        onScaleUpdate: _handleScaleUpdate,
        onTapDown: (details) {
          setState(() {
            widget.fractionalOffsets
                .add(_getOffset(context, details.globalPosition));
          });
        },
        onLongPress: _handleScaleReset,
        child: Transform(
          transform: Matrix4.diagonal3Values(_zoom, _zoom, 1.0) +
              Matrix4.translationValues(_offset.dx, _offset.dy, 0.0),
          child: Center(
            child: Container(
                child: Stack(
              children: <Widget>[
                Image.network(
                  widget.drawing["image"] ??
                      'https://picsum.photos/250?image=9',
                ),
              ]..addAll(_getOverlays(context)),
            )),
          ),
        ));
  }

  void _handleScaleStart(ScaleStartDetails details) {
    setState(() {
      _startingFocalPoint = details.focalPoint;
      _previousOffset = _offset;
      _previousZoom = _zoom;
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _zoom = _previousZoom * details.scale;

      // Ensure that item under the focal point stays in the same place despite zooming
      final Offset normalizedOffset =
          (_startingFocalPoint - _previousOffset) / _previousZoom;
      _offset = details.focalPoint - normalizedOffset * _zoom;
    });
  }

  void _handleScaleReset() {
    setState(() {
      _zoom = 1.0;
      _offset = Offset.zero;
      widget.fractionalOffsets.clear();
    });
  }

  double _width = 100;
  double _height = 50;

  List<Widget> _getOverlays(BuildContext context) {
    return widget.fractionalOffsets
        .asMap()
        .map((i, offset) => MapEntry(
            i,
            Positioned(
                left: offset.dx - _width / 2,
                width: _width,
                top: offset.dy - _height / 2,
                height: _height,
                child: _buildIcon((i + 1).toString(), context))))
        .values
        .toList();
  }

  Widget _buildIcon(String indexText, BuildContext context) {
    return FlatButton.icon(
      onPressed: () {
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("My Super title"),
              content: new Text("Hello World"),
            ));
      },
      icon: Icon(
        Icons.pin_drop,
        color: Theme.of(context).accentColor,
        size: 30,
      ),
      label: Text(
        indexText,
        style: TextStyle(
            color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCircleIcon(String indexText) {
    return Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Text(
          indexText,
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }

  // FractionalOffset _getFractionalOffset(
  //     BuildContext context, Offset globalPosition) {
  //   var renderbox = context.findRenderObject() as RenderBox;
  //   var localOffset = renderbox.globalToLocal(globalPosition);
  //   var width = renderbox.size.width;
  //   var height = renderbox.size.height;
  //   return FractionalOffset(localOffset.dx / width, localOffset.dy / height);
  // }

  vector.Matrix4 get _transformationMatrix {
    var scale = vector.Matrix4.diagonal3Values(_zoom, _zoom, 1.0);
    var translation =
        vector.Matrix4.translationValues(_offset.dx, _offset.dy, 0.0);
    var transform = translation * scale;
    return transform;
  }

  Offset _getOffset(BuildContext context, Offset globalPosition) {
    var renderbox = context.findRenderObject() as RenderBox;
    var localOffset = renderbox.globalToLocal(globalPosition);
    var localVector = vector.Vector3(localOffset.dx, localOffset.dy, 0);
    var transformed =
        vector.Matrix4.inverted(_transformationMatrix).transform3(localVector);
    return Offset(transformed.x, transformed.y);
  }
}
