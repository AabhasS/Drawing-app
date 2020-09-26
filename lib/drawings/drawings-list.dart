import 'package:doda/add-drawing/add-drawing.dart';
import 'package:doda/drawings/drawing_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawingList extends StatefulWidget {
  @override
  _DrawingListState createState() => _DrawingListState();
}

class _DrawingListState extends State<DrawingList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DrawingListBloc>(
        create: (context) => DrawingListBloc(),
        child: Scaffold(
          floatingActionButton: BlocBuilder<DrawingListBloc, DrawingListState>(
              builder: (context, state) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddDrawingForm()));
              },
              child: Icon(Icons.add),
            );
          }),
          appBar: AppBar(
            title: Text("Drawing List"),
          ),
          body: BlocBuilder<DrawingListBloc, DrawingListState>(
              builder: (context, state) {
            Widget _widget = Container(
              height: 100,
              color: Colors.redAccent,
            );
            if (state is DrawingListInitial) {
              _widget = CircularProgressIndicator();
              context.bloc<DrawingListBloc>().add(GetList());
            }
            if (state is LoadingDrawingList) {
              _widget = CircularProgressIndicator();
            }
            if (state is LoadedDrawingList) {
              _widget = ListView(
                  children: state.drawings.map((e) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(e["image"])),
                      title: Text(
                        e["title"] ?? "hh",
                      ),
                      subtitle: Text(e["markers"]?.toString() ?? "--"),
                    ),
                  ),
                );
              }).toList());
            }
            return _widget;
          }),
        ));
  }
}
