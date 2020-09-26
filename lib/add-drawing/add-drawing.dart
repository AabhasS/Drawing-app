import 'dart:io';

import 'package:doda/add-drawing/add_drawing_bloc.dart';
import 'package:doda/drawings/drawings-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddDrawingForm extends StatefulWidget {
  @override
  _AddDrawingFormState createState() => _AddDrawingFormState();
}

class _AddDrawingFormState extends State<AddDrawingForm> {
  final TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddDrawingBloc>(
        create: (context) => AddDrawingBloc(),
        child: BlocBuilder<AddDrawingBloc, AddDrawingState>(
            builder: (context, state) {
          File _image = BlocProvider.of<AddDrawingBloc>(context).image;
          Widget photoWidget = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: GestureDetector(
                onTap: () {
                  BlocProvider.of<AddDrawingBloc>(context)
                      .add(AddPicture(context: context));
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Center(
                    child: Icon(
                      Icons.camera,
                      size: 100,
                    ),
                  ),
                )),
          );
          if (state is PictureAdded && _image != null) {
            photoWidget = Center(
              child: Container(
                height: 240,
                child: Stack(
                  children: [
                    Image.file(_image),
                    Positioned(
                        child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 35,
                            ),
                            onPressed: () {
                              BlocProvider.of<AddDrawingBloc>(context)
                                  .add(AddPicture(context: context));
                            })),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text("Add Drawing"),
            ),
            body: state is UploadingDrawing
                ? CircularProgressIndicator()
                : ListView(
                    children: [
                      photoWidget,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        child: TextField(
                          decoration: new InputDecoration(
                            labelText: "Title",
                            hintText: "Enter an image name",
                          ),
                          controller: titleController,
                          onChanged: (value) {
                            BlocProvider.of<AddDrawingBloc>(context).title =
                                value;
                          },
                        ),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          BlocProvider.of<AddDrawingBloc>(context)
                              .add(SavePicture());
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => DrawingList()));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 16),
                          child: Text("Save"),
                        ),
                      )
                    ],
                  ),
          );
        }));
  }
}
