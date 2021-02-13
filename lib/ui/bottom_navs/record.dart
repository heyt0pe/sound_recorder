import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file/local.dart';
import 'package:file/file.dart';
import '../../utils/size_config.dart';

/// A stateful widget class to display the [Record] page
class Record extends StatefulWidget {
  static const String id = 'record_page';

  final LocalFileSystem localFileSystem;

  Record({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {
  ///validate form fields
  AutovalidateMode validate = AutovalidateMode.onUserInteraction;

  ///Output format variable
  AudioOutputFormat outputFormat;

  ///Text controller to get recording filename
  TextEditingController _fileName = new TextEditingController();

  ///Field decoration fo text input and drop down button
  InputDecoration kFieldDecoration = InputDecoration(
    labelText: '',
    labelStyle: TextStyle(
      fontFamily: 'Circular Std Book',
      fontSize: 15,
      color: Color(0XFF1F1F1F),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 1.5,
        color: Color(0XFF004282),
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
      borderSide: BorderSide(
        width: 1.5,
        color: Color(0XFFD70F0F),
      ),
    ),
  );

  ///Get recording state
  bool isRecording = false;

  ///button size to animate growth, shrink and pulsation
  double buttonSize = 120;

  double totalSeconds = 0;

  int animationDuration = 750;

  Timer timer;

  String time() {
    String formattedTime = '00:00';
    if (totalSeconds != 0) {
      String minutes = (totalSeconds / 60).floor().toString();
      minutes = minutes.length < 2 ? '0$minutes' : minutes;
      String seconds = (totalSeconds.toInt() % 60).toString();
      seconds = seconds.length < 2 ? '0$seconds' : seconds;
      formattedTime = '$minutes:$seconds';
    }
    return formattedTime;
  }

  void toggleRecording() async {
    setState(() {
      if (isRecording) {
        stopRecording();
      } else {
        startRecording();
      }
    });
  }

  startRecording() async {
    // Check permissions before starting
    try {
      print(Permission.microphone.isGranted);
      bool hasPermissions = await Permission.microphone.isGranted &&
          await Permission.storage.isGranted;
      if (hasPermissions) {
        String path = _fileName.text;
        if (!_fileName.text.contains('/')) {
          var appDocDirectory = await getApplicationDocumentsDirectory();
          path = appDocDirectory.path + '/' + _fileName.text;
        }
        print("Start recording: $path");
        await AudioRecorder.start(path: path, audioOutputFormat: outputFormat);
        animationDuration = 700;
        startPulsating();
        totalSeconds = 0;
        isRecording = await AudioRecorder.isRecording;
        Scaffold.of(context).showSnackBar(
          new SnackBar(
            content: new Text("Recording started"),
          ),
        );
      } else {
        await [
          Permission.microphone,
          Permission.storage,
        ].request();
      }
    } catch (e) {
      if (e.toString().substring(0, 44) ==
          'Exception: A file already exists at the path') {
        Scaffold.of(context).showSnackBar(
          new SnackBar(
            content: new Text("File name already exists"),
          ),
        );
      }
    }
    return false;
  }

  void stopRecording() async {
    var recording = await AudioRecorder.stop();
    timer.cancel();
    File file = widget.localFileSystem.file(recording.path);
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text("Recording ended"),
      ),
    );
    setState(() {
      isRecording = false;
      buttonSize = 120;
    });
  }

  void startPulsating() {
    timer = Timer.periodic(
      Duration(milliseconds: 500),
      (Timer t) {
        setState(() {
          buttonSize = buttonSize == 150 ? 130 : 150;
          totalSeconds += 0.5;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Container(
                height: 87,
                child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _fileName,
                    autovalidateMode: validate,
                    validator: (value) {
                      return value.length < 1
                          ? "Please enter a filename"
                          : null;
                    },
                    style: TextStyle(
                      fontFamily: 'Circular Std Book',
                      fontSize: 15,
                      color: Color(0XFF1F1F1F),
                    ),
                    decoration:
                        kFieldDecoration.copyWith(labelText: 'Filename')),
              ),
              Container(
                height: 87,
                child: DropdownButtonFormField(
                  value: outputFormat,
                  items: [
                    DropdownMenuItem(
                      value: AudioOutputFormat.AAC,
                      child: Text(
                        'AAC',
                        style: TextStyle(
                          fontFamily: 'Circular Std Book',
                          fontSize: 15,
                          color: Color(0XFF1F1F1F),
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: AudioOutputFormat.WAV,
                      child: Text(
                        'WAV',
                        style: TextStyle(
                          fontFamily: 'Circular Std Book',
                          fontSize: 15,
                          color: Color(0XFF1F1F1F),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (selectedValue) {
                    setState(() {
                      outputFormat = selectedValue;
                    });
                  },
                  autovalidateMode: validate,
                  validator: (value) {
                    return outputFormat == null
                        ? "Please select a format"
                        : null;
                  },
                  decoration:
                      kFieldDecoration.copyWith(labelText: 'Output Format'),
                ),
              ),
              SizedBox(
                height: 55,
              ),
              Container(
                width: 150,
                height: 150,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (outputFormat == null || _fileName.text.length < 1) {
                        setState(() {
                          validate = AutovalidateMode.always;
                        });
                      } else {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        toggleRecording();
                      }
                    },
                    child: AnimatedContainer(
                        duration: new Duration(milliseconds: animationDuration),
                        width: buttonSize,
                        height: buttonSize,
                        decoration: BoxDecoration(
                          color: isRecording
                              ? Color(0XFF004282)
                              : Color(0XFFAAAAAA),
                          borderRadius: BorderRadius.all(
                            Radius.circular(buttonSize / 2),
                          ),
                        ),
                        child: Icon(Icons.mic, size: 55)),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                time(),
                style: TextStyle(
                  fontFamily: 'Circular Std Book',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF1F1F1F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
