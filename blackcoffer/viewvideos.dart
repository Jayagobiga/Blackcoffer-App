import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:share/share.dart';

void main() {
  runApp(MaterialApp(
    home: DisplayVideos(),
  ));
}

class Video {
  final String url;
  final String title;
  final String description;
  final String category;
  final String location;

  Video({required this.url, required this.title, required this.description,required this.category,required this.location});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      url: json['url'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      location: json['location'],
    );
  }
}

class DisplayVideos extends StatefulWidget {
  @override
  _DisplayVideosState createState() => _DisplayVideosState();
}

class _DisplayVideosState extends State<DisplayVideos> {
  late Future<List<Video>> _videos;

  @override
  void initState() {
    super.initState();
    _videos = fetchVideoUrls();
  }

  Future<List<Video>> fetchVideoUrls() async {
    final response = await http.post(Uri.parse("http://192.168.1.27:80/blackcoffer/fetchvideos.php"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> videosJson = data['videos'];
      List<Video> videos = videosJson.map((video) => Video.fromJson(video)).toList();

      // Log the videos
      for (var video in videos) {
        print('Video URL: ${video.url}, Title: ${video.title}, Description: ${video.description},Category: ${video.category},Location: ${video.location}');
      }

      return videos;
    } else {
      throw Exception('Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player Demo',style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent, // Set deep purple color for AppBar
      ),
      body: FutureBuilder<List<Video>>(
        future: _videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No videos found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: VideoPlayerItem(video: snapshot.data![index]),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final Video video;

  const VideoPlayerItem({Key? key, required this.video}) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  int _likeCount = 0;
  int _dislikeCount = 0;
  int _viewCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.url);
    _initializeVideoPlayerFuture = _controller.initialize();
    _viewCount = 0; // Initialize view count
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_controller.value.isPlaying;
    });
  }

  void _incrementLike() {
    setState(() {
      _likeCount++;
    });
  }

  void _incrementDislike() {
    setState(() {
      _dislikeCount++;
    });
  }

  void _incrementView() {
    setState(() {
      _viewCount++;
    });
  }

  void _shareVideo() {
    Share.share(widget.video.url);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (_controller.value.hasError) {
                      return Center(child: Text('Error: ${_controller.value.errorDescription}'));
                    }
                    return AspectRatio(
                      aspectRatio: 16/9, // Set 16:9 aspect ratio here
                      child: VideoPlayer(_controller),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              GestureDetector(
                onTap: () {
                  _togglePlayPause();
                  _incrementView();
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 64.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: _incrementLike,
                ),
                Text('$_likeCount'),
                IconButton(
                  icon: Icon(Icons.thumb_down),
                  onPressed: _incrementDislike,
                ),
                Text('$_dislikeCount'),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: _shareVideo,
                ),
                IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: _incrementView,
                ),
                Text('$_viewCount'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              widget.video.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
            child: Text(widget.video.description),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
            child: Text(widget.video.category),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
            child: Text(widget.video.location),
          ),
        ],
      ),
    );
  }
}
