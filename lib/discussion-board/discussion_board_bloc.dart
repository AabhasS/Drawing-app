import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doda/firebase-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'discussion_board_event.dart';
part 'discussion_board_state.dart';

class DiscussionBoardBloc
    extends Bloc<DiscussionBoardEvent, DiscussionBoardState> {
  FirebaseService _firebaseService = FirebaseService();
  DiscussionBoardBloc() : super(DiscussionBoardInitial());

  @override
  Stream<DiscussionBoardState> mapEventToState(
    DiscussionBoardEvent event,
  ) async* {
    if (event is GetMarkers) {
      yield* _getMarkerOffset(await _updatedList(event.drawing["docId"]));
    }
    if (event is CreateMarker) {
      yield UploadingMarker();
      if (await _addMarkerToFirebase(event.drawingId, event.markerPosition,
          title: event.title, description: event.description)) {
        yield* _getMarkerOffset(await _updatedList(event.drawingId));
      }
    }
  }

  Stream<DiscussionBoardState> _getMarkerOffset(
      List<dynamic> markerList) async* {
    List<Map<String, dynamic>> offsetList = [];
    markerList.forEach((element) {
      offsetList.add(element);
    });
    yield MarkersLoaded(markerList: offsetList);
  }

  Future<bool> _addMarkerToFirebase(String drawingId, Offset markerPosition,
      {String title, String description}) async {
    await _firebaseService.updateDrawing(drawingId, markerPosition,
        title: title, description: description);

    return Future.value(true);
  }

  _updatedList(String drawingId) {
    return _firebaseService.getMarkers(drawingId);
  }
}
