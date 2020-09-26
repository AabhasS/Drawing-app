import 'package:flutter/material.dart';

class ImageWithOverlays extends StatefulWidget {
  final Map<String, dynamic> drawing;
  final List<FractionalOffset> fractionalOffsets;
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
                .add(_getFractionalOffset(context, details.globalPosition));
          });
        },
        onDoubleTap: _handleScaleReset,
        child: Transform(
          transform: Matrix4.diagonal3Values(_zoom, _zoom, 1.0) *
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

  List<Widget> _getOverlays(BuildContext context) {
    return widget.fractionalOffsets
        .asMap()
        .map((i, fo) => MapEntry(
            i,
            Align(
                alignment: fo, child: _buildIcon((i + 1).toString(), context))))
        .values
        .toList();
  }

  Widget _buildIcon(String indexText, BuildContext context) {
    return FlatButton.icon(
      icon: Icon(Icons.location_on, color: Colors.red),
      label: Text(
        indexText,
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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

  FractionalOffset _getFractionalOffset(
      BuildContext context, Offset globalPosition) {
    var renderbox = context.findRenderObject() as RenderBox;
    var localOffset = renderbox.globalToLocal(globalPosition);
    var width = renderbox.size.width;
    var height = renderbox.size.height;
    return FractionalOffset(localOffset.dx / width, localOffset.dy / height);
  }
}
