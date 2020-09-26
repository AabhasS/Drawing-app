import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'discussion_board_event.dart';
part 'discussion_board_state.dart';

class DiscussionBoardBloc
    extends Bloc<DiscussionBoardEvent, DiscussionBoardState> {
  DiscussionBoardBloc() : super(DiscussionBoardInitial());

  @override
  Stream<DiscussionBoardState> mapEventToState(
    DiscussionBoardEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
