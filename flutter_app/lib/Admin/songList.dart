import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class SongList extends StatefulWidget {
  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  // Varaibles Declaration
  List _songAll = [];
  Map tempData;
  File _pickedSong;

  @override
  void initState() {
    listSongs();
    super.initState();
  }

// Fetching all songs
  void listSongs() async {
    _songAll = [];
    await FirebaseStorage.instance
        .ref()
        .child('song')
        .listAll()
        .then((result) => {
              tempData = result['items'],
            });
    tempData.forEach((itemMainName, valueInsideMain) {
      setState(() {
        _songAll.add(valueInsideMain['name']);
      });
    });
  }

  //Add Song

  void _addSong() async {
    print("Adding Song ...");
    _pickedSong = await FilePicker.getFile();
    String _songName = _pickedSong.path.split('/').last;
    final StorageReference firebaseStorageRefernce =
        await FirebaseStorage.instance.ref().child('song').child(_songName);
    final StorageUploadTask task =
        await firebaseStorageRefernce.putFile(_pickedSong);
    listSongs();
  }

// Delete Song
  void deleteSong(songtoDelete) async {
    print("Deleting");
    final StorageReference firebaseStorageRefernce =
        await FirebaseStorage.instance.ref().child('song').child(songtoDelete);
    await firebaseStorageRefernce.delete().then((value) => {listSongs()});
  }

// Refersh Songs
  refreshSongList() {
    listSongs();
  }

// Confirm Delete

  Future<void> _openUserDetails(songName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do You want to Delete '),
          actions: <Widget>[
            FlatButton(
              child: Text('Confirm Delete'),
              onPressed: () {
                deleteSong(songName);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Widgets
  // Song List Building
  Widget _songListBuilder() {
    return ListView.builder(
        itemCount: _songAll.length,
        itemBuilder: (context, int index) {
          return ListTile(
            onLongPress: () {
              _openUserDetails(_songAll[index]);
            },
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              child: Text("A"),
            ),
            title: Text(_songAll[index]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All Songs"),
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh), onPressed: refreshSongList)
          ],
        ),
        body: _songListBuilder(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
          onPressed: _addSong,
        ));
  }
}
