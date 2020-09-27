import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarkerList extends StatelessWidget {
  final List<Map<String, dynamic>> markerList;
  MarkerList({@required this.markerList});
  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('dd/MM/yy H:mm');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text("All Markers"),
      ),
      body: ListView(
        children: markerList.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                  title: Text(
                    e["title"] ?? "hh",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${e["description"] ?? 0}"),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Text(e["timeStamp"] != null
                              ? formatter.format(DateTime.parse(e["timeStamp"]))
                              : "")),
                    ],
                  )),
            ),
          );
        }).toList(),
      ),
    );
  }
}
