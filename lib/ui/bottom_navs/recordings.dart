import 'package:flutter/material.dart';
import '../../utils/size_config.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:audioplayers/audioplayers.dart';

/// A stateful widget class to display the [Recordings] page
class Recordings extends StatefulWidget {
  static const String id = 'recordings_page';

  @override
  _RecordingsState createState() => _RecordingsState();
}

class _RecordingsState extends State<Recordings> {
  String directory;
  List files = new List();

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _listFiles();
  }

  // Make New Function
  void _listFiles() async {
    directory = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      files = Directory("$directory/").listSync();
    });
  }

  List<Widget> recordings() {
    List<Widget> allRecordings = [
      Container(),
    ];
    try {
      if (files == []) {
        return allRecordings;
      }
      print(files[2].toString().split('\''));
      for (var item in files.reversed) {
        String fileName = item.toString().split("'")[1];
        if (item.toString().substring(0, 4) == 'File' &&
            (fileName.substring(fileName.length - 3) == 'm4a' ||
                fileName.substring(fileName.length - 3) == 'wav')) {
          print(fileName);
          allRecordings.add(
            Container(
              width: SizeConfig.screenWidth,
              height: 55,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0XFF1F1F1F),
                    width: 1,
                  ),
                ),
                color: Color(0XFFFFFFFF),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth - 120,
                      child: Text(
                        fileName.split('/').last,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'Circular Std Book',
                          fontSize: 16,
                          color: Color(0XFF1F1F1F),
                        ),
                      ),
                    ),
                    Container(
                      width: 75,
                      child: PopupMenuButton(
                        child: new ListTile(
                          trailing: const Icon(Icons.more_vert),
                        ),
                        onSelected: (String selected) async {
                          if (selected.split('*/*')[0] == 'Play') {
                            await audioPlayer.play(
                              selected.split('*/*')[1],
                              isLocal: true,
                            );
                          } else if (selected.split('*/*')[0] == 'Share') {
                            Share.shareFiles(
                              [selected.split('*/*')[1]],
                              text: selected.split('*/*')[1].split('/').last,
                            );
                          } else if (selected.split('*/*')[0] == 'Delete') {
                            final fileToDelete =
                                Directory(selected.split('*/*')[1]);
                            fileToDelete.deleteSync(recursive: true);
                            _listFiles();
                            recordings();
                          }
                        },
                        itemBuilder: (_) => <PopupMenuItem<String>>[
                          new PopupMenuItem<String>(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Icon(
                                    Icons.play_arrow,
                                  ),
                                ),
                                Text('Play'),
                              ],
                            ),
                            value: 'Play*/*$fileName',
                          ),
                          new PopupMenuItem<String>(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Icon(
                                    Icons.share,
                                  ),
                                ),
                                Text('Share'),
                              ],
                            ),
                            value: 'Share*/*$fileName',
                          ),
                          new PopupMenuItem<String>(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Icon(
                                    Icons.delete,
                                  ),
                                ),
                                Text('Delete'),
                              ],
                            ),
                            value: 'Delete*/*$fileName',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      print(e);
    }
    return allRecordings;
  }

  Future refresh() async {
    _listFiles();
    recordings();
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            children: [Text(files.toString())] + recordings(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          audioPlayer.stop();
        },
        child: Icon(
          Icons.stop,
        ),
      ),
    );
  }
}
