part of 'add_drawing_bloc.dart';

@immutable
abstract class AddDrawingState {}

class AddDrawingInitial extends AddDrawingState {}

class PictureAdded extends AddDrawingState {
  final bool processing;
  PictureAdded({@required this.processing});
}

class UploadedDrawing extends AddDrawingState {}

class UploadingDrawing extends AddDrawingState {}
