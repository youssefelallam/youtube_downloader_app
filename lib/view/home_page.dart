import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:youtube_download/controller/data_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 39, 39, 43),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Youtube Download'),
      ),
      body: Consumer<DataProvider>(
        builder: (context, controller, child) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.white,
                        controller: controller.UrlController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Url',
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () => controller
                          .getVideeoInfo(controller.UrlController.text),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                controller.videoID.isEmpty
                    ? Text('')
                    : Image.network(
                        'https://img.youtube.com/vi/${controller.videoID}/0.jpg',
                        scale: 1.4),
                SizedBox(height: 3),
                Text(controller.videoTitle),
                SizedBox(height: 3),
                controller.videoID.isEmpty
                    ? Text('')
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: 0,
                                    groupValue: controller.value,
                                    onChanged: (int? value) {
                                      setState(() => controller.value = value!);
                                    },
                                  ),
                                  Text('Video'),
                                ],
                              ),
                              SizedBox(width: 15),
                              Row(
                                children: [
                                  Radio(
                                    value: 1,
                                    groupValue: controller.value,
                                    onChanged: (int? value) {
                                      setState(() => controller.value = value!);
                                    },
                                  ),
                                  Text('Audio'),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          TextButton.icon(
                            onPressed: controller.start
                                ? null
                                : () {
                                    controller.downloadVideo(
                                        controller.UrlController.text);
                                  },
                            icon: Icon(Icons.download),
                            label: Text('Download Video'),
                          ),
                        ],
                      ),
                controller.progress > 0
                    ? Column(
                        children: [
                          Text(
                              '${controller.progress == 2 ? '100' : (controller.progress * 100).toInt()} %',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: controller.progress,
                            backgroundColor: Colors.grey,
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        ],
                      )
                    : Text(''),
              ],
            ),
          );
        },
      ),
    );
  }
}
