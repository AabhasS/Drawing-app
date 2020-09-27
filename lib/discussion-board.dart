import 'package:doda/discussion-board/discussion_board_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vector_math/vector_math.dart' as vector;

class DrawingWithMarkers extends StatefulWidget {
  final Map<String, dynamic> drawing;
  DrawingWithMarkers({this.drawing});

  @override
  _DrawingWithMarkersState createState() => _DrawingWithMarkersState();
}

class _DrawingWithMarkersState extends State<DrawingWithMarkers> {
  Offset _startingFocalPoint;
  Offset _previousOffset;
  Offset _offset = Offset.zero;

  double _previousZoom;
  double _zoom = 1.0;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiscussionBoardBloc>(
      create: (context) => DiscussionBoardBloc(),
      child: BlocBuilder<DiscussionBoardBloc, DiscussionBoardState>(
          builder: (context, state) {
        List<Widget> markerWidgets = [
          Center(child: CircularProgressIndicator())
        ];
        if (state is DiscussionBoardInitial) {
          BlocProvider.of<DiscussionBoardBloc>(context)
              .add(GetMarkers(drawing: widget.drawing));
        }

        if (state is MarkersLoaded) {
          markerWidgets.clear();
          markerWidgets = _getOverlays(context, state.markerList);
        }

        if (state is UploadingMarker) {}

        return GestureDetector(
            onScaleStart: _handleScaleStart,
            onScaleUpdate: _handleScaleUpdate,
            onTapDown: (details) {
              showDialog(
                  context: context,
                  child: new AlertDialog(
                    actions: [
                      RaisedButton(
                        onPressed: () {
                          BlocProvider.of<DiscussionBoardBloc>(context).add(
                              CreateMarker(
                                  drawingId: widget.drawing["docId"],
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  markerPosition: _getOffset(
                                      context, details.globalPosition)));
                          Navigator.of(context).pop();
                        },
                        color: Theme.of(context).accentColor,
                        child: Text("Create"),
                      )
                    ],
                    title: TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: "Title"),
                    ),
                    content: TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: "Description"),
                    ),
                  ));
            },
            // onLongPress: _handleScaleReset,
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
                      fit: BoxFit.fill,
                    ),
                  ]..addAll(markerWidgets),
                )),
              ),
            ));
      }),
    );
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

  // void _handleScaleReset() {
  //   setState(() {
  //     _zoom = 1.0;
  //     _offset = Offset.zero;
  //     widget.fractionalOffsets.clear();
  //   });
  // }

  double _width = 200;
  double _height = 50;

  List<Widget> _getOverlays(
      BuildContext context, List<Map<String, dynamic>> markerList) {
    return markerList.map((marker) {
      return Positioned(
          left: marker["offset"]["x"] - _width / 2,
          width: _width,
          top: marker["offset"]["y"] - _height / 2,
          height: _height,
          child: _buildIcon(context, marker));
    }).toList();
  }

  Widget _buildIcon(BuildContext context, Map<String, dynamic> marker) {
    return FlatButton.icon(
      onPressed: () {
        showDialog(
            context: context,
            child: AlertDialog(
                title: Text(marker["offset"]["title"].toString().length != 0
                    ? marker["offset"]["title"]
                    : "No data"),
                content: Container(
                  height: 100,
                  child: Text(marker["offset"]["description"] ?? "No data"),
                )));
      },
      icon: Icon(
        Icons.location_on,
        color: Theme.of(context).accentColor,
        size: 30,
      ),
      label: Text(
        "",
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
