import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:fntat/Components/constants.dart';

class VideoApp extends StatefulWidget {
  final String videoUrl;
  final String userName;
  VideoApp({
    required this.videoUrl,
    required this.userName,
  });
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  var videoPosition;
  var videoDuration;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        setState(() {
          videoPosition = _controller.value.position;
        });
      })
      ..initialize().then((_) {
        setState(() {
          videoDuration = _controller.value.duration;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      appBar: AppBar(
        backgroundColor: KPrimaryColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: KSubPrimaryColor,
          ),
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
        title: Text(
          "Skills Video",
          style: KScreenTitlesStyle2,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(
              '${widget.userName} Skills',
              style: KNameStyle,
            ),
            SizedBox(
              height: 30.0,
            ),
            if (_controller.value.isInitialized) ...[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 700.0,
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    Container(
                      width: 700.0,
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        padding: EdgeInsets.all(5.0),
                        colors: VideoProgressColors(
                          backgroundColor: KSubPrimaryColor,
                          bufferedColor: KSubPrimaryColor,
                          playedColor: KPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: _controller.value.isInitialized &&
              videoPosition != videoDuration
          ? FloatingActionButton(
              backgroundColor: KPrimaryColor,
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: KSubPrimaryColor,
                size: 35.0,
              ),
            )
          : FloatingActionButton(
              backgroundColor: KPrimaryColor,
              onPressed: () {
                setState(() {
                  _controller.play();
                });
              },
              child: Icon(
                Icons.play_arrow,
                color: KSubPrimaryColor,
                size: 35.0,
              ),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
