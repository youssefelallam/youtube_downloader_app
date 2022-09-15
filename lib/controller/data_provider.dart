import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DataProvider extends ChangeNotifier {
  TextEditingController UrlController = TextEditingController();
  String videoID = '';
  String videoTitle = '';
  double progress = 0;
  int value = 0;
  bool start = false;

  //get info function
  Future<void> getVideeoInfo(url) async {
    try {
      var youtubeInfo = YoutubeExplode();
      var video = await youtubeInfo.videos.get(url);
      videoID = video.id.toString();
      videoTitle = video.title;
      notifyListeners();
    } catch (e) {
      videoID = '';
      videoTitle = '';
      notifyListeners();
    }
  }

  //download function
  Future<void> downloadVideo(url) async {
    var permisson = await Permission.storage.request();
    if (permisson.isGranted) {
      progress = 0;
      start = true;
      notifyListeners();
      var youtubeExplode = YoutubeExplode();
      //get meta data video
      var video = await youtubeExplode.videos.get(url);
      var manifest = await youtubeExplode.videos.streamsClient.getManifest(url);
      var streams = value > 0
          ? manifest.audio.withHighestBitrate()
          : manifest.muxed.withHighestBitrate();
      var audio = streams;
      var audioStream = youtubeExplode.videos.streamsClient.get(audio);
      //create a directory
      Directory? directory = await getExternalStorageDirectory();
      String appDocPath = "";
      List<String> folders = directory!.path.split('/');
      for (int x = 1; x < folders.length; x++) {
        String folder = folders[x];
        if (folder != "Android") {
          appDocPath += "/" + folder;
        } else {
          break;
        }
      }
      String sc_path = value > 0 ? 'Audio' : 'Video';
      String homePath = appDocPath + '/Ydown/';
      appDocPath = homePath + sc_path;

      directory = Directory(homePath);
      var directory1 = Directory(appDocPath);
      if (!await directory.exists()) {
        directory.create();
        directory1.create();
      } else {
        if (!await directory1.exists()) {
          directory1.create();
        }
      }
      // String appDocPath = appDocDir.path;
      String extention = value > 0 ? 'mp3' : 'mp4';
      var file = File('$appDocPath/${video.title}.$extention');
      //delete file if exists
      if (file.existsSync()) {
        file.deleteSync();
      }
      var output = file.openWrite(mode: FileMode.writeOnlyAppend);
      var size = audio.size.totalBytes;
      var count = 0;

      await for (final data in audioStream) {
        // Keep track of the current downloaded data.
        count += data.length;
        // Calculate the current progress.
        double val = ((count / size));
        // var msg = '${video.title} Downloaded to $appDocPath/${video.id}';
        // for (val; val == 1.0; val++) {
        //   // ScaffoldMessenger.of(context)
        //   //     .showSnackBar(SnackBar(content: Text(msg)));
        // }
        progress = val;
        notifyListeners();

        // Write to file.
        output.add(data);
      }
      start = false;
      notifyListeners();
    } else {
      await Permission.storage.request();
    }
  }
}
