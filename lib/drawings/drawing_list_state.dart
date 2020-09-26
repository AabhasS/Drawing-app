part of 'drawing_list_bloc.dart';

@immutable
abstract class DrawingListState {}

class DrawingListInitial extends DrawingListState {}

class LoadedDrawingList extends DrawingListState {
  final List<Map<String, dynamic>> drawings;

  LoadedDrawingList({@required this.drawings});
}

class LoadingDrawingList extends DrawingListState {}
