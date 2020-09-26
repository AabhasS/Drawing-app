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
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
            child: GestureDetector(
                onTap: () {
                  BlocProvider.of<AddDrawingBloc>(context)
                      .add(AddPicture(context: context));
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.2)),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.camera,
                        color: Colors.black.withOpacity(0.2),
                        size: 100,
                      ),
                      Text(
                        "Add Picture",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
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
              backgroundColor: Theme.of(context).accentColor,
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
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                        child: RaisedButton(
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
                            child: Text(
                              "Save",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
          );
        }));
  }
}
