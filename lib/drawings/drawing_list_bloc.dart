import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doda/firebase-service.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'drawing_list_event.dart';
part 'drawing_list_state.dart';

class DrawingListBloc extends Bloc<DrawingListEvent, DrawingListState> {
  DrawingListBloc() : super(DrawingListInitial());
  FirebaseService _firebaseService = FirebaseService();
  bool change = false;
  @override
  Stream<DrawingListState> mapEventToState(
    DrawingListEvent event,
  ) async* {
    if (event is GetList) {
      yield LoadingDrawingList();
      try {
        yield* _getList();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Stream<DrawingListState> _getList() async* {
    List<Map<String, dynamic>> list = await _firebaseService.getDrawings();

    yield LoadedDrawingList(drawings: list);
  }
}
