import 'package:flutter/material.dart';
import 'package:flutter_app/Admin/songList.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  // Widgets
  // List All song Card
  Widget _listAllSongCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SongList()),
          );
        },
        child: Card(
            child: Center(
          child: Text("List All Songs"),
        )),
      ),
    );
  }

  // List All User Card
  Widget _listAllUserCard() {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      child: Card(
          child: Center(
        child: Text("List Users"),
      )),
    );
  }

  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _listAllSongCard(),
          _listAllUserCard(),
        ],
      ),
    );
  }
}
