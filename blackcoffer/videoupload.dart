import 'package:blackcoffer/videodash.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'viewvideos.dart'; // Import your ViewVideosPage
import 'package:http/http.dart' as http;

class RecordAndPostVideoPage extends StatefulWidget {
  @override
  _RecordAndPostVideoPageState createState() => _RecordAndPostVideoPageState();
}

class _RecordAndPostVideoPageState extends State<RecordAndPostVideoPage> {
  final ImagePicker _picker = ImagePicker();
  File? _videoFile;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _uploadVideo() async {
    if (_videoFile == null) return;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.27:80/blackcoffer/uploadvideo.php'),
    );
    request.fields['title'] = _titleController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['category'] = _categoryController.text;
    request.fields['location'] = _locationController.text;
    request.fields['date_time'] = _dateTimeController.text;

    request.files.add(await http.MultipartFile.fromPath(
      'video',
      _videoFile!.path,
    ));

    var res = await request.send();
    if (res.statusCode == 200) {
      print('Uploaded!');
      _navigateToViewVideosPage();
    } else {
      print('Upload failed!');
    }
  }

  Future<void> _fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);
    Placemark place = placemarks[0];

    setState(() {
      _locationController.text =
      '${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }

  Future<void> _pickVideo() async {
    final pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      setState(() {
        _videoFile = File(pickedVideo.path);
      });
      _fetchLocation(); // Fetch location when the video is picked
      _updateDateTime(); // Update date and time when the video is picked
    }
  }

  Future<void> _recordVideo() async {
    final pickedVideo = await _picker.pickVideo(source: ImageSource.camera);
    if (pickedVideo != null) {
      setState(() {
        _videoFile = File(pickedVideo.path);
      });
      _fetchLocation(); // Fetch location when the video is recorded
      _updateDateTime(); // Update date and time when the video is recorded
    }
  }

  void _updateDateTime() {
    DateTime now = DateTime.now();
    setState(() {
      _dateTimeController.text = now.toString();
    });
  }

  void _navigateToViewVideosPage() {
    //Navigate to ViewVideosPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VideoDash()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
        title: Text(
          'Record and Post Video',
          style: TextStyle(color: Colors.white,fontStyle:FontStyle.italic,fontSize: 20,fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.video_library),
                              title: Text('Select Video from Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickVideo();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.videocam),
                              title: Text('Record Video'),
                              onTap: () {
                                Navigator.pop(context);
                                _recordVideo();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  'Upload or Record Video',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              if (_videoFile != null)
                Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9, // Fixed aspect ratio
                      child: VideoPlayerWidget(videoFile: _videoFile!),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Video Category',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Video Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _dateTimeController,
                decoration: InputDecoration(
                  labelText: 'Date and Time',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _uploadVideo(); // Call the upload video function
                    },
                    child: Text(
                      'Post Video',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;

  VideoPlayerWidget({required this.videoFile});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(() {
      if (_controller.value.isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16 / 9, // Fixed aspect ratio
                child: VideoPlayer(_controller),
              ),
              IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
