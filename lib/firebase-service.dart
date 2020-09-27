import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseService {
  final database = Firestore.instance;

  Future<List<Map<String, dynamic>>> getDrawings() async {
    List<Map<String, dynamic>> list = [];
    await database.collection("drawings").get().then((value) {
      value.docs.forEach((element) {
        Map<String, dynamic> map = element.data();
        map["docId"] = element.id;
        list.add(map);
      });
    });
    return Future.value(list);
  }

  Stream<QuerySnapshot> listenToChange() {
    return database.collection("drawings").snapshots();
  }

  Future<void> createDrawing(String url, String title) async {
    database.collection("drawings").add({
      'title': title,
      'image': url,
      'timeStamp': DateTime.now().toIso8601String()
    }).catchError((e) {
      print("Failed uploading");
    });
  }

  Future<bool> updateDrawing(String docId, Offset offset,
      {String title, String description}) async {
    bool success = false;
    await database.collection("drawings").doc(docId).update({
      "markers": FieldValue.arrayUnion([
        {
          "offset": {
            "x": offset.dx,
            "y": offset.dy,
            "title": title ?? "",
            "description": description ?? ""
          }
        }
      ])
    }).whenComplete(() {
      success = true;
    });

    return Future.value(success);
  }

  Future<List<dynamic>> getMarkers(docId) async {
    List<dynamic> markers;
    await database.collection("drawings").doc(docId).get().then((value) {
      markers = value.data()["markers"];
    });

    return Future.value(markers);
  }
}
