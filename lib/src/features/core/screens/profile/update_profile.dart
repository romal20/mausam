import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mausam/src/constants/colors.dart';
import 'package:mausam/src/constants/image_strings.dart';
import 'package:mausam/src/constants/sizes.dart';
import 'package:mausam/src/constants/text_strings.dart';
import 'package:mausam/src/features/authentication/models/user_model.dart';
import 'package:mausam/src/features/core/controllers/profile_controller.dart';
//import 'package:mausam/src/features/authentication/models/user_model.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  String name = "";
  String email = "";

  void getData() async {
    User? user = await FirebaseAuth.instance.currentUser;
    var vari = await FirebaseFirestore.instance.collection("Users").doc(user?.uid).get();
    setState(() {
      name = vari.data()?['Name'];
      email = vari.data()?['Email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(LineAwesomeIcons.angle_left)),
          title: Text("Edit Profile", style: Theme.of(context).textTheme.headlineMedium,),
        ),
        body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(defaultSize),
              child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: const Image(image: AssetImage(profileImage))),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: primaryColor,
                              ),
                              child: const Icon(LineAwesomeIcons.camera,
                                  size: 20, color: Colors.black)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Form(
                        child: Column(
                          children: [
                            TextFormField(
                              //initialValue: userData.fullName,
                                decoration: InputDecoration(
                                  label: Text(name),
                                  prefixIcon: Icon(Icons.person_outline_rounded),
                                )),
                            const SizedBox(height: 10.0),
                            /* TextFormField(
                                          //initialValue: userData.phoneNo,
                                        controller: phoneNo,
                                          decoration: const InputDecoration(
                                            label: Text("Phone Number"),
                                            prefixIcon: Icon(Icons.numbers),
                                          )),*/
                            const SizedBox(height: 10.0),
                            TextFormField(
                              //initialValue: userData.email,
                                decoration: InputDecoration(
                                  label: Text(email),
                                  prefixIcon: Icon(Icons.email_outlined),
                                )),
                            const SizedBox(height: 10.0),
                            TextFormField(
                              // initialValue: userData.password,
                                decoration: const InputDecoration(
                                  label: Text("Password"),
                                  prefixIcon: Icon(Icons.fingerprint),
                                )),
                            const SizedBox(
                              height: 30.0,
                            ),
                            SizedBox(
                              width: double.infinity,
                              /*child: ElevatedButton(
                                  onPressed: () async {
                                    final userData = UserModel(
                                      email: email.text.trim(),
                                      password: password.text.trim(),
                                      name: fullName.text.trim(),
                                      //phoneNo: phoneNo.text.trim(),
                                    );
                                    await controller.updateRecord(userData);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      side: BorderSide.none,
                                      shape: const StadiumBorder()),
                                  child: const Text("Edit Profile",
                                      style: TextStyle(color: darkColor))),
*/                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text.rich(const TextSpan(
                                    text: "Joined ",
                                    style: const TextStyle(fontSize: 12),
                                    children: [
                                      const TextSpan(
                                          text: JoinedAt,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 12))
                                    ])),
                                ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent.withOpacity(0.1),
                                        elevation: 0,
                                        foregroundColor: Colors.red,
                                        shape: const StadiumBorder(),
                                        side: BorderSide.none),
                                    child: const Text("Delete"))
                              ],
                            )
                          ],
                        )
                    )
                  ],
              )
              /*child: SingleChildScrollView(
                child: FutureBuilder(
                  future: controller.getUserData(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.hasData){UserModel userData = snapshot.data as UserModel;
                      final email = TextEditingController(text: userData.email);
                      final password = TextEditingController(text: userData.password);
                      final fullName = TextEditingController(text: userData.name);
                     // final phoneNo = TextEditingController(text: userData.phoneNo);
                        return Column(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: const Image(image: AssetImage(profileImage))),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: primaryColor,
                                        ),
                                        child: const Icon(LineAwesomeIcons.camera,
                                            size: 20, color: Colors.black)),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Form(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        //initialValue: userData.fullName,
                                        controller: fullName,
                                          decoration: const InputDecoration(
                                            label: Text("Full Name"),
                                            prefixIcon: Icon(Icons.person_outline_rounded),
                                          )),
                                      const SizedBox(height: 10.0),
                                     */


              /* TextFormField(
                                          //initialValue: userData.phoneNo,
                                        controller: phoneNo,
                                          decoration: const InputDecoration(
                                            label: Text("Phone Number"),
                                            prefixIcon: Icon(Icons.numbers),
                                          )),*/

              /*
                                      const SizedBox(height: 10.0),
                                      TextFormField(
                                          //initialValue: userData.email,
                                        controller: email,
                                          decoration: const InputDecoration(
                                            label: Text("Email"),
                                            prefixIcon: Icon(Icons.email_outlined),
                                          )),
                                      const SizedBox(height: 10.0),
                                      TextFormField(
                                         // initialValue: userData.password,
                                        controller: password,
                                          decoration: const InputDecoration(
                                            label: Text("Password"),
                                            prefixIcon: Icon(Icons.fingerprint),
                                          )),
                                      const SizedBox(
                                        height: 30.0,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              final userData = UserModel(
                                              email: email.text.trim(),
                                              password: password.text.trim(),
                                              name: fullName.text.trim(),
                                              //phoneNo: phoneNo.text.trim(),
                                              );
                                              await controller.updateRecord(userData);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: primaryColor,
                                                side: BorderSide.none,
                                                shape: const StadiumBorder()),
                                            child: const Text("Edit Profile",
                                                style: TextStyle(color: darkColor))),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text.rich(const TextSpan(
                                              text: "Joined ",
                                              style: const TextStyle(fontSize: 12),
                                              children: [
                                                const TextSpan(
                                                    text: JoinedAt,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 12))
                                              ])),
                                          ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                                                  elevation: 0,
                                                  foregroundColor: Colors.red,
                                                  shape: const StadiumBorder(),
                                                  side: BorderSide.none),
                                              child: const Text("Delete"))
                                        ],
                                      )
                                    ],
                                  )
                              )
                            ]);
                      }else if(snapshot.hasError){
                        return Center(child: Text(snapshot.error.toString()));
                      }else {
                        return const Center(child: Text('Something went wrong'));
                      }
                    }else{
                      return const Center(child: CircularProgressIndicator());
                    }
                  }
                ),
              ),*/
            )
        )
    );
  }
}