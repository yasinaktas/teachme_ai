import 'package:flutter/material.dart';

class AddCoursePage extends StatelessWidget {
  const AddCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Stepper(
          onStepContinue: () {},
          onStepCancel: () {},

          steps: [
            Step(
              title: Text("What do you want to learn?"),
              label: Text("Deneme"),

              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Course Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            Step(
              title: Text("Review and adjust the subtitles"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Course Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
