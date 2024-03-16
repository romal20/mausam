import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    TextEditingController _controller = TextEditingController();
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 2.0,
        centerTitle: true,
        title: Text("Feedback",style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,fontWeight: FontWeight.bold,fontSize: 20)),
        leading: IconButton(
          onPressed: (){Navigator.pop(context);},
          icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
          height: 350,
          child: Stack(
            children: [
              Center(
                child: TextField(
                  controller: _controller,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      hintText: "We'd love to hear your thoughts! \nEnter your feedback here..",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xffc5c5c5),
                      ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.black,width: 3,style: BorderStyle.solid)),
                      border: OutlineInputBorder(borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.black,width: 7,style: BorderStyle.solid)),
                  ),
                ),
              ),
            ],
          ),
        ),
            //buildFeedbackForm(),
            SizedBox(height: 20,),
           //buildNumberField(),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                    // Only if the input form is valid (the user has entered text)
                      try {
                        final user = FirebaseAuth.instance.currentUser;
                        final userId = user != null ? user.uid : 'unknown';
                        final email = user != null ? user.email : 'unknown@example.com';
                        // Get a reference to the `feedback` collection
                        final collection = FirebaseFirestore.instance.collection('Feedback');
                        // Write the server's timestamp and the user's feedback
                        await collection.doc().set({
                          'userId': userId,
                          'email':email,
                          'timestamp': FieldValue.serverTimestamp(),
                          'feedback': _controller.text,
                        });
                        Get.snackbar("Feedback Sent","Thank you for your feedback! Your opinion is important to us.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green.withOpacity(0.1),
                            colorText: Colors.green);
                        Navigator.pop(context);
                      } catch (e) {
                        Get.snackbar("Feedback Submission Failed","There was an error while submitting your feedback. Please try again.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.withOpacity(0.1),
                            colorText: Colors.red);
                      }
                    },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(isDarkMode ? Color(
                        0xffdedede) : Color(0xffdedede)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16.0)),
                  ),
                  child: Center(
                    child: Text(
                      "Send Feedback",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  buildFeedbackForm() {
    TextEditingController _controller = TextEditingController();
    return Container(
      height: 350,
      child: Stack(
        children: [
          Center(
            child: TextField(
              controller: _controller,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "We'd love to hear your thoughts! \nEnter your feedback here..",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xffc5c5c5),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffe5e5e5))
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}