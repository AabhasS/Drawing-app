import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:doda/firebase-service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'add_drawing_event.dart';
part 'add_drawing_state.dart';

class AddDrawingBloc extends Bloc<AddDrawingEvent, AddDrawingState> {
  AddDrawingBloc() : super(AddDrawingInitial());

  FirebaseService _firebaseService = FirebaseService();
  final ImagePicker _imagePicker = ImagePicker();
  File image;
  String title;

  @override
  Stream<AddDrawingState> mapEventToState(
    AddDrawingEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is AddPicture) {
      image = await getImageFromImagePicker(event.context);
      yield PictureAdded(processing: true);
    }

    if (event is SavePicture) {
      yield UploadingDrawing();
      if (image != null && (title.isNotEmpty || title != null)) {
        yield* _uploadDrawing(image, title);
      }
    }
  }

  Future<File> getImageFromImagePicker(BuildContext context) async {
    PickedFile pickedFile = await showDialog<PickedFile>(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: Text('Camera'),
                          )),
                      onTap: () async {
                        PickedFile file = await _imagePicker.getImage(
                            source: ImageSource.camera);
                        print(file.path);
                        Navigator.of(context).pop(file);
                      }),
                  GestureDetector(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Icon(Icons.photo),
                            title: Text('Gallery'),
                          )),
                      onTap: () async {
                        PickedFile file = await _imagePicker.getImage(
                            source: ImageSource.gallery);
                        print(file.path);
                        Navigator.of(context).pop(file);
                      }),
                ],
              ),
            ));
    if (pickedFile == null || pickedFile.path == null) return null;
    return File(pickedFile.path);
  }

  Stream<AddDrawingState> _uploadDrawing(File file, String filename) async* {
    StorageReference storageReference;

    storageReference = FirebaseStorage.instance.ref().child("images/$filename");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    _firebaseService.createDrawing(url, filename);

    yield UploadedDrawing();
  }
}
