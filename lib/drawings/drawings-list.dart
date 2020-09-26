import 'package:doda/add-drawing/add-drawing.dart';
import 'package:doda/drawing-profile.dart';
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
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddDrawingForm()));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          title: Center(child: Text("Drawing List")),
        ),
        body: BlocProvider(
          create: (context) => DrawingListBloc(),
          child: BlocBuilder<DrawingListBloc, DrawingListState>(
              builder: (context, state) {
            Widget _widget = Container(
              height: 100,
              color: Colors.redAccent,
            );
            if (state is DrawingListInitial) {
              BlocProvider.of<DrawingListBloc>(context).add(GetList());
            } else if (state is LoadingDrawingList) {
              _widget = Center(child: CircularProgressIndicator());
            } else if (state is LoadedDrawingList) {
              _widget = ListView(
                  children: state.drawings.map((e) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DrawingProfile(
                                drawing: e,
                              )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(e["image"])),
                        title: Text(
                          e["title"] ?? "hh",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(e["markers"]?.toString() ?? "--"),
                      ),
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
