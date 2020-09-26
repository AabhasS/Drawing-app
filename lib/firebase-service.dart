import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final database = Firestore.instance;

  Future<List<Map<String, dynamic>>> getDrawings() async {
    List<Map<String, dynamic>> list = [];
    database.collection("drawings").get().then((value) {
      value.docs.forEach((element) {
        list.add(element.data());
      });
    });
    return list;
  }

  Future<void> createDrawing(String url, String title) async {
    database.collection("drawings").add({
      'title': title,
      'image': url,
    }).catchError((e) {
      print("Failed uploading");
    });
  }
}
