import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi/src/fire_base/users.dart';
import 'package:taxi/src/resources/dialog/loading_dialog.dart';

import '../model/user.dart';

class Profile extends StatefulWidget {
  final User user;
  const Profile(this.user, {Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<User>? updated;
  XFile? dp;
  @override
  void initState() {
    updated = getUserById(widget.user.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: updated,
        initialData: widget.user,
        builder: (context, snapshot) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Column(children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: (widget.user.dp == null)
                            ? const Icon(Icons.person, size: 28)
                            : null,
                        foregroundImage: (snapshot.data!.dp == null)
                            ? null
                            : NetworkImage(snapshot.data!.dp!),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          child: const Icon(Icons.add_a_photo),
                          onTap: () async {
                            try {
                              ImagePicker picker = ImagePicker();
                              dp = await picker.pickImage(
                                  source: ImageSource.gallery);

                              if (dp != null) {
                                LoadingDialog.showLoadingDialog(
                                    context, "Updating dp");
                                var response = await updateDp(dp!);
                                LoadingDialog.hideLoadingDialog(context);
                                if (response) {
                                  setState(() {
                                    updated = getUserById(widget.user.id!);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Error updating dp"),
                                    backgroundColor: Colors.red,
                                  ));
                                  return;
                                }
                              }
                            } catch (err) {
                              return;
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  TextField(
                      enabled: false,
                      controller:
                          TextEditingController(text: snapshot.data!.name),
                      decoration: const InputDecoration(labelText: "Name")),
                  TextField(
                      enabled: false,
                      controller:
                          TextEditingController(text: snapshot.data!.phone),
                      decoration: const InputDecoration(labelText: "Phone")),
                  const SizedBox(height: 5),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Rating"),
                    subtitle: (widget.user.rating == 0.0)
                        ? const Text("You have no ratings yet")
                        : RatingBarIndicator(
                            itemCount: 5,
                            rating: snapshot.data!.rating,
                            itemBuilder: (context, index) {
                              return const Icon(Icons.star,
                                  color: Colors.amber);
                            }),
                  ),
                  (widget.user.driver == false)
                      ? const SizedBox.shrink()
                      : Column(children: [
                          TextField(
                            controller: TextEditingController(
                                text: snapshot.data!.license),
                            decoration:
                                const InputDecoration(labelText: "License No"),
                          )
                        ])
                ]),
              ),
            ],
          );
        });
  }
}
