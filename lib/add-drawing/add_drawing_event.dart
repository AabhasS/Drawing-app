part of 'add_drawing_bloc.dart';

@immutable
abstract class AddDrawingEvent {}

class AddPicture extends AddDrawingEvent {
  final BuildContext context;
  final String title;

  AddPicture({@required this.context, this.title});
}

class SavePicture extends AddDrawingEvent {}
