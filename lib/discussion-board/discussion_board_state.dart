part of 'discussion_board_bloc.dart';

@immutable
abstract class DiscussionBoardState {}

class DiscussionBoardInitial extends DiscussionBoardState {}

class MarkersLoaded extends DiscussionBoardState {
  final List<Map<String, dynamic>> markerList;

  MarkersLoaded({@required this.markerList});
}

class UploadingMarker extends DiscussionBoardState {}
