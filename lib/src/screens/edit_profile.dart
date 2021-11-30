import 'dart:io';
import 'dart:io' as io;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_novel/blocs/authentication_bloc.dart';
import 'package:my_novel/events/authentication_event.dart';
import 'package:my_novel/services/profile_service.dart';
import 'package:my_novel/services/user_service.dart';
import 'package:my_novel/states/authentication_state.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({Key? key}) : super(key: key);

  @override
  EditProfileWidgetState createState() => EditProfileWidgetState();
}

enum SingingCharacter { male, female }
enum statusUpdateAvatar { sucess, fail, failUploadStorage, failUpdateFirestore }

class EditProfileWidgetState extends State<EditProfileWidget>
    with SingleTickerProviderStateMixin {
  late final ProfileService _profileService;
  late final UserService _userService;
  bool _status = true;
  bool _status2 = true;
  final FocusNode myFocusNode = FocusNode();
  late TextEditingController _nameController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  SingingCharacter? _character = SingingCharacter.male;
  File? _imageFile = File('');
  final picker = ImagePicker();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    _nameController = TextEditingController();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _profileService = ProfileService();
    _userService = UserService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authenticationState) {
        if (authenticationState is AuthenticationStateSuccess) {
          _nameController.text = authenticationState.profile!.fullName!;
          return Scaffold(
            body: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 250.0,
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.black,
                                      size: 22.0,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 25.0),
                                    child: Text(
                                      'PROFILE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          fontFamily: 'sans-serif-light',
                                          color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child:
                                  Stack(fit: StackFit.loose, children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 140.0,
                                      height: 140.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: (_imageFile!.path == '')
                                            ? DecorationImage(
                                                image: CachedNetworkImageProvider(
                                                    (authenticationState
                                                                .profile!
                                                                .avatar ==
                                                            '')
                                                        ? 'https://cdn.tricera.net/images/no-avatar.jpg'
                                                        : authenticationState
                                                            .profile!.avatar!),
                                                fit: BoxFit.cover,
                                              )
                                            : DecorationImage(
                                                image: FileImage(_imageFile!),
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: pickImage,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 90.0, right: 100.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 25.0,
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            )
                          ],
                        ),
                      ),
                      (_imageFile!.path == '')
                          ? const Center()
                          : Container(
                              padding: const EdgeInsets.only(top: 0),
                              child: RaisedButton(
                                child: const Text("Upload Avatar"),
                                textColor: Colors.white,
                                color: Colors.green,
                                onPressed: () async {
                                  statusUpdateAvatar status =
                                      await uploadImageToFirebase(
                                          authenticationState.profile!.id!);
                                  if (status == statusUpdateAvatar.sucess) {
                                    BlocProvider.of<AuthenticationBloc>(context)
                                        .add(
                                      AuthenticationEventFetchData(),
                                    );
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                      Container(
                        color: const Color(0xffFFFFFF),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Text(
                                          'Parsonal Information',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        _status ? _getEditIcon() : Container(),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Text(
                                          'Name',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        controller: _nameController,
                                        decoration: const InputDecoration(
                                          hintText: "Enter Your Name",
                                        ),
                                        enabled: !_status,
                                        autofocus: !_status,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Text(
                                          'Gender',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: ListTile(
                                              title: const Text('Male'),
                                              leading: Radio<SingingCharacter>(
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                value: SingingCharacter.male,
                                                groupValue: _character,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  setState(() {
                                                    !_status
                                                        ? _character =
                                                            SingingCharacter
                                                                .male
                                                        : null;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              title: const Text('Female'),
                                              leading: Radio<SingingCharacter>(
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                value: SingingCharacter.female,
                                                groupValue: _character,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  setState(() {
                                                    !_status
                                                        ? _character = value
                                                        : null;
                                                  });
                                                },
                                                autofocus: !_status,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              !_status
                                  ? _getActionButtons(
                                      context, authenticationState.profile!.id!)
                                  : Container(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const <Widget>[
                                        Text(
                                          'Change Password',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        _status2
                                            ? _getEditIcon2()
                                            : Container(),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              !_status2
                                  ? _getActionChangePassword()
                                  : Container(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return Center();
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile!.path != '') {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<bool> updatePersonalInformation(
      String id, String name, String gender) async {
    return await _profileService.updatePersonalInformation(id, name, gender);
  }

  Future<bool> updateAvatarFirestore(String id, String avatar) async {
    return await _profileService.updateAvatar(id, avatar);
  }

  Future<statusUpdateAvatar> uploadImageToFirebase(String id) async {
    statusUpdateAvatar status = statusUpdateAvatar.fail;
    String fileName = basename(_imageFile!.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users')
        .child('/$fileName');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    firebase_storage.UploadTask uploadTask;
    //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask = ref.putFile(io.File(_imageFile!.path), metadata);

    firebase_storage.UploadTask task = await Future.value(uploadTask);
    await Future.value(uploadTask)
        .then((value) async => {
              debugPrint(
                  "Upload file path ${await value.ref.getDownloadURL()}"),
              if (await updateAvatarFirestore(
                  id, await value.ref.getDownloadURL()))
                {status = statusUpdateAvatar.sucess}
              else
                {status = statusUpdateAvatar.failUpdateFirestore}
            })
        .onError((error, stackTrace) => {
              debugPrint("Upload file path error ${error.toString()} "),
              status = statusUpdateAvatar.failUploadStorage
            });
    debugPrint(status.toString());
    return status;
  }

  Widget _getActionButtons(BuildContext context, String id) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                child: const Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () async {
                  String gender =
                      _character == SingingCharacter.male ? 'male' : 'female';
                  bool status = await updatePersonalInformation(
                      id, _nameController.text, gender);
                  if (status) {
                    setState(() {
                      _status = true;
                      BlocProvider.of<AuthenticationBloc>(context).add(
                        AuthenticationEventFetchData(),
                      );
                    });
                    Fluttertoast.showToast(
                      msg: "Update Succesfull",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                child: const Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getActionChangePassword() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Text(
                    'Current Password',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _currentPasswordController,
                  decoration: const InputDecoration(
                    hintText: "Enter Your Current Password",
                  ),
                  enabled: !_status2,
                  autofocus: !_status2,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Text(
                    'New Password',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    hintText: "Enter Your New Password",
                  ),
                  enabled: !_status2,
                  autofocus: !_status2,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    child: const Text("Save"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () async {
                      bool check = await _userService.changePassword(
                          _currentPasswordController.text,
                          _newPasswordController.text);
                      debugPrint(check.toString());
                      setState(() {
                        if (check) {
                          Fluttertoast.showToast(
                            msg: "Change Password Succesfull",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          _status = true;
                        } else {
                          Fluttertoast.showToast(
                            msg: "Current Password Wrong",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          _status = true;
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                flex: 2,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    child: const Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _status2 = true;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                flex: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: const CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Widget _getEditIcon2() {
    return GestureDetector(
      child: const CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status2 = false;
        });
      },
    );
  }
}
