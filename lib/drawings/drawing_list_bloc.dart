import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'drawing_list_event.dart';
part 'drawing_list_state.dart';

class DrawingListBloc extends Bloc<DrawingListEvent, DrawingListState> {
  DrawingListBloc() : super(DrawingListInitial());

  @override
  Stream<DrawingListState> mapEventToState(
    DrawingListEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
