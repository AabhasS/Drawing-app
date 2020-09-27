part of 'discussion_board_bloc.dart';

@immutable
abstract class DiscussionBoardEvent {}

class AddMarker extends DiscussionBoardEvent {
  final Offset position;

  AddMarker(this.position);
}

class GetMarkers extends DiscussionBoardEvent {
  final Map<String, dynamic> drawing;

  GetMarkers({@required this.drawing});
}

class CreateMarker extends DiscussionBoardEvent {
  final String drawingId;
  final Offset markerPosition;
  final String title;
  final String description;

  CreateMarker(
      {@required this.markerPosition,
      @required this.drawingId,
      this.title,
      this.description});
}
