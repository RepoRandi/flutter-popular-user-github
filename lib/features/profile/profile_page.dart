import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popular_user_github/data/database_helper/database_helper.dart';
import 'package:popular_user_github/data/local_storage_helper/local_storage_helper.dart';
import 'package:popular_user_github/models/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _initializeProfileData();
  }

  Future<void> _initializeProfileData() async {
    await _saveProfileData();
    setState(() {});
  }

  File? _imageFile;
  String? _imageName;

  double _longitude = 0.0;
  double _latitude = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileInfo(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSavedImage() async {
    try {
      final savedImage = await LocalStorageHelper.loadImage(_imageName!);
      if (savedImage != null) {
        setState(() {
          _imageFile = savedImage;
        });
      }
    } catch (e) {
      print('Error loading saved image: $e');
    }
  }

  Widget _buildProfileInfo() {
    return FutureBuilder<Profile?>(
      future: DatabaseHelper.instance.getProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No profile data available.');
        } else {
          final profile = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    _imageFile != null
                        ? ClipOval(
                            child: Image.file(
                              _imageFile!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const CircleAvatar(
                            radius: 75,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person,
                                size: 75, color: Colors.white),
                          ),
                    const SizedBox(height: 16),
                    Text('${profile?.name}Randi Maulana A'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('E-mail'),
                    Text('${profile?.email}devs.randi@gmail.com'),
                    const Divider(),
                    Text('${profile?.position}Mobile Developer'),
                    const Divider(),
                    const Text('Longitude'),
                    Text('$_longitude'),
                    const Divider(),
                    const Text('Latitude'),
                    Text('$_latitude'),
                    const Divider(),
                  ],
                ),
              )
            ],
          );
        }
      },
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: _refreshGeolocation,
              child: const Text('Refresh Geolocation'),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: _capturePhoto,
              child: const Text('Capture Photo'),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: _selectFromGallery,
              child: const Text('Select from Gallery'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshGeolocation() async {
    Location location = Location();

    try {
      LocationData currentLocation = await location.getLocation();
      setState(() {
        _longitude = currentLocation.longitude ?? 0.0;
        _latitude = currentLocation.latitude ?? 0.0;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _capturePhoto() async {
    final imagePicker = ImagePicker();

    try {
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _imageName = _imageFile!.path.split('/').last;
        });

        await LocalStorageHelper.saveImage(_imageFile!, _imageName!);
        await _loadSavedImage();
      }
    } catch (e) {
      print('Error capturing photo: $e');
    }
  }

  Future<void> _selectFromGallery() async {
    final imagePicker = ImagePicker();

    try {
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _imageName = _imageFile!.path.split('/').last;
        });

        await LocalStorageHelper.saveImage(_imageFile!, _imageName!);
        await _loadSavedImage();
      }
    } catch (e) {
      print('Error selecting from gallery: $e');
    }
  }

  Future<void> _saveProfileData() async {
    final profile = Profile(
        name: 'Randi Maulana A',
        email: 'devs.randi@gmail.com',
        position: 'Mobile Developer');

    try {
      await DatabaseHelper.instance.insertProfile(profile);

      if (_imageFile != null && _imageName != null) {
        final localImage = await _saveImageToLocal(_imageFile!, _imageName!);
      }

      setState(() {});
    } catch (e) {
      print('Error saving profile data: $e');
    }
  }

  Future<File> _saveImageToLocal(File imageFile, String imageName) async {
    final directory = await getApplicationDocumentsDirectory();
    final localImagePath = '${directory.path}/$imageName';
    final localImage = await imageFile.copy(localImagePath);

    setState(() {
      _imageFile = localImage;
    });

    return localImage;
  }
}
