import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:fntat/Components/constants.dart';

class SkillsVideo extends StatefulWidget {
  final String videoUrl;
  final String userName;
  SkillsVideo({required this.videoUrl, required this.userName});
  @override
  _SkillsVideoState createState() => _SkillsVideoState();
}

class _SkillsVideoState extends State<SkillsVideo> {
  late BetterPlayerController videoController;
  GlobalKey videoGlobalKey = GlobalKey();

  @override
  void initState() {
    BetterPlayerConfiguration videoConfiguration =
        BetterPlayerConfiguration(aspectRatio: 16 / 9, fit: BoxFit.contain);
    BetterPlayerDataSource videoSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoUrl,
    );
    videoController = BetterPlayerController(videoConfiguration);
    videoController.setupDataSource(videoSource);
    videoController.setBetterPlayerGlobalKey(videoGlobalKey);
    super.initState();
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
      body: Column(
        children: [
          SizedBox(
            height: 30.0,
          ),
          Text(
            '${widget.userName} Skills',
            style: KNameStyle,
          ),
          SizedBox(
            height: 60.0,
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(
              key: videoGlobalKey,
              controller: videoController,
            ),
          ),
        ],
      ),
    );
  }
}
