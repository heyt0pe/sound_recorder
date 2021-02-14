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

  void _listFiles() async {
    directory = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      files = Directory("$directory/").listSync();
    });
  }

  void play(String fileName) async {
    await audioPlayer.play(
      fileName,
      isLocal: true,
    );
  }

  void share(String fileName) {
    Share.shareFiles(
      [fileName],
      text: fileName.split('/').last,
    );
  }

  void delete(String fileName) {
    final fileToDelete = Directory(fileName);
    fileToDelete.deleteSync(recursive: true);
    _listFiles();
    recordings();
  }

  List<Widget> recordings() {
    List<Widget> allRecordings = [
      Container(),
    ];
    try {
      if (files == []) {
        return allRecordings;
      }
      for (var item in files.reversed) {
        String fileName = item.toString().split("'")[1];
        if (item.toString().substring(0, 4) == 'File' &&
            (fileName.substring(fileName.length - 3) == 'm4a' ||
                fileName.substring(fileName.length - 3) == 'wav')) {
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
                      width: SizeConfig.screenWidth - 175,
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
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                          ),
                          onPressed: () {
                            play(fileName);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.share,
                          ),
                          onPressed: () {
                            share(fileName);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                          ),
                          onPressed: () {
                            delete(fileName);
                          },
                        ),
                      ],
                    )
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
      backgroundColor: Color(0XFFFFFFFF),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            children: recordings(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.deepOrange,
          onPressed: () {
            audioPlayer.stop();
          },
          label: Row(
            children: [
              Text('Stop'),
              Icon(
                Icons.stop,
              )
            ],
          )),
    );
  }
}
