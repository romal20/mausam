import 'package:flutter/material.dart';

import '../../../../constants/image_strings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Center(
              child: Container(
                height: 130,width: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,width: 5
                  )
                ),
                child: Image(image: NetworkImage(profileImage),
                  loadingBuilder: (context,child,loadingProgress){
                    return CircularProgressIndicator();
                  },
                errorBuilder: (context,object,stack){
                  return Container(
                    child: Icon(Icons.error_outline,color: Colors.blue,),
                  );
                },),

              ),
            )
          ],
        ),
      ),
    );
  }
}
