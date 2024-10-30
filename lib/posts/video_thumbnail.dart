// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoThumbnail extends StatefulWidget {
//   final String videoUrl;
//   final VoidCallback onPlay; // Callback to handle play button tap

//   const VideoThumbnail({
//     super.key,
//     required this.videoUrl,
//     required this.onPlay,
//   });

//   @override
//   VideoThumbnailState createState() => VideoThumbnailState();
// }

// class VideoThumbnailState extends State<VideoThumbnail> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
//       ..initialize().then((_) {
//         setState(() {
//           _isInitialized = true;
//         });
//         // Pause the video after the first frame is loaded
//         _controller.pause();
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isInitialized
//         ? Stack(
//             alignment: Alignment.center,
//             children: [
//               AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               ),
//               // Play button overlay
//               IconButton(
//                 icon: const Icon(
//                   Icons.play_circle_fill,
//                   size: 64,
//                   color: Colors.white,
//                 ),
//                 onPressed: widget.onPlay,
//               ),
//             ],
//           )
//         : const Center(child: CircularProgressIndicator());
//   }
// }
