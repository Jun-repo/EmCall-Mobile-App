// import 'package:flutter/material.dart';
// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:video_player/video_player.dart';

// // VideoHandler widget
// class VideoHandler extends StatefulWidget {
//   final String videoUrl;

//   const VideoHandler({super.key, required this.videoUrl});

//   @override
//   VideoHandlerState createState() => VideoHandlerState();
// }

// class VideoHandlerState extends State<VideoHandler> {
//   late FlickManager flickManager;

//   @override
//   void initState() {
//     super.initState();
//     flickManager = FlickManager(
//       videoPlayerController: VideoPlayerController.networkUrl(
//         Uri.parse(widget.videoUrl),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     flickManager.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FlickVideoPlayer(flickManager: flickManager);
//   }
// }
