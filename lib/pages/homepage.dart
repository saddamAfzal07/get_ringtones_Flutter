// import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_sound/public/flutter_sound_player.dart';

class DefaultRingtonesPage extends StatefulWidget {
  @override
  _DefaultRingtonesPageState createState() => _DefaultRingtonesPageState();
}

class _DefaultRingtonesPageState extends State<DefaultRingtonesPage> {
  List<String> defaultRingtones = [];
  String selectedRingtone = '';
  final FlutterSoundPlayer flutterSoundPlayer = FlutterSoundPlayer();
  String? currentlyPlayingRingtone; // Variable to track the currently

  @override
  void initState() {
    super.initState();
    fetchDefaultRingtones();
    initializePlayer();
  }

  void initializePlayer() async {
    await flutterSoundPlayer
        .openAudioSession(); // Open the audio session before performing any operations
  }

  void fetchDefaultRingtones() async {
    Directory ringtoneDir = Directory(
        '/system/media/audio/ringtones'); // Path to the default ringtone directory

    if (await ringtoneDir.exists()) {
      List<FileSystemEntity> ringtoneFiles = ringtoneDir.listSync();

      List<String> ringtones = ringtoneFiles
          .where((file) => file is File)
          .map((file) => file.path)
          .toList();

      setState(() {
        defaultRingtones = ringtones;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Default Ringtones'),
      ),
      body: ListView.builder(
        itemCount: defaultRingtones.length,
        itemBuilder: (context, index) {
          String ringtonePath = defaultRingtones[index];
          String ringtoneName = ringtonePath.split('/').last;
          return ListTile(
            title: Text(ringtoneName),
            onTap: () {
              // Play the selected ringtoneY
              playRingtone(ringtonePath);
              setState(() {
                selectedRingtone =
                    ringtoneName; // Set the selected ringtone name
              });
            },
            trailing: selectedRingtone == ringtoneName
                ? Icon(Icons
                    .volume_up) // Show an indicator icon for the selected ringtone
                : null,
          );
        },
      ),
    );
  }

  // void playRingtone(String ringtonePath) async {
  //   AudioPlayer audioPlayer = AudioPlayer();
  //   int result = await audioPlayer.play(ringtonePath, isLocal: true);
  //   if (result == 1) {
  //     // success
  //   }
  // }
  // void playRingtone(String ringtonePath) {
  //   print("ringtonePath===>>>>>${ringtonePath}");
  //   print("call ringtone");
  //   FlutterRingtonePlayer.play(
  //     android: AndroidSounds.notification,
  //     ios: IosSounds.glass,
  //     looping: false,
  //     volume: 1.0,
  //   );
  // }
  // void playRingtone(String ringtonePath) async {
  //   try {
  //     final file = File(ringtonePath);
  //     final String uriString = file.uri.toString();
  //     await audioPlayer.setFilePath(uriString);
  //     await audioPlayer.play();
  //   } catch (e) {
  //     print('Error playing audio: $e');
  //   }
  // }
//working
  // void playRingtone(String ringtonePath) async {
  //   print("Enter into Rington");
  //   final flutterSoundPlayer = FlutterSoundPlayer();

  //   try {
  //     await flutterSoundPlayer.openAudioSession();
  //     await flutterSoundPlayer.startPlayer(fromURI: ringtonePath);
  //   } catch (e) {
  //     print('Error playing audio: $e');
  //   }
  // }
  //stop multiple ringtones
  void playRingtone(String ringtonePath) async {
    print("Enter into Rington");
    try {
      if (currentlyPlayingRingtone != null) {
        await flutterSoundPlayer
            .stopPlayer(); // Stop the currently playing ringtone
      }

      if (ringtonePath == currentlyPlayingRingtone) {
        currentlyPlayingRingtone =
            ""; // If the same ringtone is clicked again, stop playback
      } else {
        final file = File(ringtonePath);
        final String uriString = file.uri.toString();
        await flutterSoundPlayer.startPlayer(fromURI: uriString);
        currentlyPlayingRingtone =
            ringtonePath; // Set the currently playing ringtone
      }

      setState(() {
        selectedRingtone = ringtonePath.split('/').last;
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  // @override
  // void dispose() {
  //   flutterSoundPlayer.release(); // Release the audio session when the widget is disposed
  //   super.dispose();
  // }
}
