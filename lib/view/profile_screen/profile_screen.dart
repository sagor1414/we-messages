import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:schats/common_Widget/dialouges.dart';
import 'package:schats/controller/controller.dart';
import 'package:schats/main.dart';
import 'package:schats/model/user_model.dart';
import 'package:schats/view/auth_screen/login_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreeen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreeen({super.key, required this.user});

  @override
  State<ProfileScreeen> createState() => _ProfileScreeenState();
}

class _ProfileScreeenState extends State<ProfileScreeen> {
  final formkey = GlobalKey<FormState>();
  String? _images;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //app bar
        appBar: AppBar(
          title: "Profile Screen".text.color(Colors.black).size(18).make(),
        ),
        //add mesage buttun
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.green,
            onPressed: () async {
              if (formkey.currentState!.validate()) {
                formkey.currentState!.save();
                Controller.updateUserInfo().then((value) {
                  VxToast.show(context, msg: "Update sucessfully");
                });
              }
            },
            label: const Text("Update"),
            icon: const Icon(Icons.edit),
          ),
        ),

        body: Form(
          key: formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .05, vertical: mq.height * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                  ),
                  //image field
                  Stack(
                    children: [
                      _images != null
                          //local image
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: Image.file(
                                File(_images!),
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.cover,
                              ),
                            )

                          //image from server
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: CachedNetworkImage(
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                  child: Icon(CupertinoIcons.person_alt),
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          onPressed: () {
                            _showBottomSheet();
                          },
                          elevation: 1,
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: const Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  widget.user.email.text.color(Colors.black54).size(16).make(),
                  SizedBox(
                    height: mq.height * .04,
                  ),
                  //name feild
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (value) => Controller.me!.name = value ?? '',
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Required Field',
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: "abcd zyx",
                        label: "Name".text.make()),
                  ),
                  SizedBox(
                    height: mq.height * .02,
                  ),
                  //about feild
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (value) => Controller.me!.about = value ?? '',
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Required Field',
                    decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.info_outline, color: Colors.green),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: "felling happy",
                        label: "About".text.make()),
                  ),
                  SizedBox(
                    height: mq.height * .15,
                  ),
                  //update button
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: const StadiumBorder(),
                          minimumSize: Size(mq.width * .5, mq.height * .06)),
                      onPressed: () async {
                        Dialogs.showProgressBar(context);
                        await Controller.authController.signOut().then(
                          (value) async {
                            await GoogleSignIn().signOut().then(
                              (value) {
                                Get.back();
                                Get.offAll(() => const LoginScreen());
                              },
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.logout,
                        size: 26,
                      ),
                      label: "Log Out".text.size(16).make())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .06),
            children: [
              "Pick a Profile Picture"
                  .text
                  .size(20)
                  .semiBold
                  .align(TextAlign.center)
                  .make(),
              15.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 70);
                        if (image != null) {
                          setState(() {
                            _images = image.path;
                          });
                          Controller.updateProfilePicture(File(_images!));
                          Get.back();
                        }
                      },
                      child: Image.asset('assets/add_image.png')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          setState(() {
                            _images = image.path;
                          });
                          Controller.updateProfilePicture(File(_images!));
                          Get.back();
                        }
                      },
                      child: Image.asset('assets/camera.png'))
                ],
              )
            ],
          );
        });
  }
}
