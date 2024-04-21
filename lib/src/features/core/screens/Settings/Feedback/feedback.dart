import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  buildFeedbackForm() {
    // Define a function named buildFeedbackForm
    TextEditingController _controller = TextEditingController(); // Create a TextEditingController instance for managing the text field's text
    return Container( // Return a Container widget
      height: 350, // Set the height of the container to 350
      child: Stack( // Use a Stack widget to allow stacking multiple widgets on top of each other
        children: [ // Define the children widgets of the Stack
          Center( // Center widget to center its child
            child: TextField( // TextField widget for user input
              controller: _controller,
              // Assign the TextEditingController to the TextField
              maxLines: 10,
              // Allow up to 10 lines of text
              keyboardType: TextInputType.multiline,
              // Set the keyboard type to multiline
              decoration: InputDecoration( // Define the input decoration for the TextField
                  hintText: "We'd love to hear your thoughts! \nEnter your feedback here..",
                  // Set the hint text for the TextField
                  hintStyle: TextStyle( // Define the style for the hint text
                    fontSize: 14, // Set the font size of the hint text to 14
                    color: Color(
                        0xffc5c5c5), // Set the color of the hint text to a light gray
                  ),
                  border: OutlineInputBorder( // Define the border of the input field
                      borderSide: BorderSide(color: Color(
                          0xffe5e5e5)) // Set the border color to a light gray
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define the build method for the FeedbackPage widget
    final isDarkMode = MediaQuery
        .of(context)
        .platformBrightness ==
        Brightness.dark; // Check if the current theme is dark mode
    TextEditingController _controller = TextEditingController(); // Create a TextEditingController for managing the text field's text
    return Scaffold( // Return a Scaffold widget
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      // Set the background color of the scaffold based on the theme
      appBar: AppBar( // Define the app bar for the scaffold
        iconTheme: IconThemeData(color: Colors.black),
        // Set the icon color of the app bar
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        // Set the background color of the app bar based on the theme
        elevation: 2.0,
        // Set the elevation of the app bar
        centerTitle: true,
        // Center the title of the app bar
        title: Text("Feedback", style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20)),
        // Set the title of the app bar
        leading: IconButton( // Define the leading icon button of the app bar
            onPressed: () {
              Navigator.pop(context);
            },
            // Pop the current route from the navigation stack when the button is pressed
            icon: Icon(Icons.arrow_back,
                color: isDarkMode ? Colors.white : Colors
                    .black)), // Set the icon of the leading button
      ),
      body: Padding( // Define the body of the scaffold
        padding: EdgeInsets.all(16.0), // Set padding for the body content
        child: Column( // Define a column layout for the body content
          crossAxisAlignment: CrossAxisAlignment.start,
          // Align the children of the column to the start (left)
          children: [
            // Define the children widgets of the column
            Container( // Create a container widget
              height: 350, // Set the height of the container
              child: Stack( // Use a stack widget to overlay multiple widgets
                children: [ // Define the children widgets of the stack
                  Center( // Center widget to center its child
                    child: TextField( // TextField widget for user input
                      controller: _controller,
                      // Assign the TextEditingController to the TextField
                      maxLines: 10,
                      // Allow up to 10 lines of text
                      keyboardType: TextInputType.multiline,
                      // Set the keyboard type to multiline
                      decoration: InputDecoration( // Define the input decoration for the TextField
                        hintText: "We'd love to hear your thoughts! \nEnter your feedback here..",
                        // Set the hint text for the TextField
                        hintStyle: TextStyle( // Define the style for the hint text
                          fontSize: 14, // Set the font size of the hint text
                          color: Color(
                              0xffc5c5c5), // Set the color of the hint text to a light gray
                        ),
                        focusedBorder: OutlineInputBorder( // Define the border when the TextField is focused
                            borderRadius: BorderRadius.all(Radius.circular(
                                5.0)), // Set the border radius
                            borderSide: BorderSide(color: isDarkMode ? Colors
                                .white : Colors.black,
                                width: 3,
                                style: BorderStyle.solid)),
                        // Set the border color and width
                        border: OutlineInputBorder(borderSide: BorderSide(
                            color: isDarkMode ? Colors.white : Colors.black,
                            width: 7,
                            style: BorderStyle
                                .solid)), // Set the border color and width
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //buildFeedbackForm(), // Placeholder for a custom feedback form widget
            SizedBox(height: 20,),
            // Add a sized box for spacing
            //buildNumberField(), // Placeholder for a custom number field widget
            Row( // Create a row widget for the send feedback button
              children: [ // Define the children widgets of the row
                Expanded( // Use an expanded widget to make the button take up all available horizontal space
                    child: TextButton( // TextButton widget for sending feedback
                      onPressed: () async { // Define the button's onPressed callback
                        // Only if the input form is valid (the user has entered text)
                        try { // Try to send feedback
                          final user = FirebaseAuth.instance
                              .currentUser; // Get the current user
                          final userId = user != null
                              ? user.uid
                              : 'unknown'; // Get the user ID or set to 'unknown' if user is null
                          final email = user != null
                              ? user.email
                              : 'unknown@example.com'; // Get the user's email or set to a default value
                          // Get a reference to the `feedback` collection
                          final collection = FirebaseFirestore.instance
                              .collection('Feedback');
                          // Write the server's timestamp and the user's feedback
                          await collection.doc().set({
                            'userId': userId,
                            'email': email,
                            'timestamp': FieldValue.serverTimestamp(),
                            'feedback': _controller.text,
                          });
                          Get.snackbar("Feedback Sent",
                              "Thank you for your feedback! Your opinion is important to us.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.withOpacity(0.1),
                              colorText: Colors
                                  .green); // Show a success snackbar
                          Navigator.pop(
                              context); // Pop the current route from the navigation stack
                        } catch (e) { // Catch any errors
                          Get.snackbar("Feedback Submission Failed",
                              "There was an error while submitting your feedback. Please try again.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red.withOpacity(0.1),
                              colorText: Colors.red); // Show an error snackbar
                        }
                      },
                      style: ButtonStyle( // Define the style for the button
                        backgroundColor: MaterialStateProperty.all<Color>(
                            isDarkMode ? Color(
                                0xffdedede) : Color(0xffdedede)),
                        // Set the background color of the button based on the theme
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(
                                16.0)), // Set the padding of the button
                      ),
                      child: Center( // Center widget to center the button text
                        child: Text(
                          "Send Feedback", // Text displayed on the button
                          style: TextStyle( // Define the text style of the button text
                            color: Colors.black, // Set the text color
                            fontWeight: FontWeight
                                .bold, // Set the font weight to bold
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
}