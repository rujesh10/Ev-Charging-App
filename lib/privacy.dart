import 'package:flutter/material.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Text(
                      "Privacy & Policy",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'We take your privacy seriously. This Privacy Policy outlines how we collect, use, and safeguard your information when you use our Electric Vehicle (EV) application.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Information Collection and Usage\n\nWhen you use our EV application, we may collect certain information such as location data, vehicle information, and user preferences. This information is used solely to enhance your experience with the application, provide personalized services, and improve our offerings.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Location Information\n\nOur EV application may request access to your device\'s location services to provide features like mapping and navigation. This information is used solely within the application and is never shared with third parties without your explicit consent.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Data Security\n\nWe implement industry-standard security measures to protect your information from unauthorized access or disclosure. We regularly review and update our security practices to ensure your data remains safe.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Third-Party Integration\n\nOur application may integrate with third-party services or APIs to enhance functionality. Please be aware that these services have their own privacy policies and terms of use, which are not governed by our Privacy Policy.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Data Retention\n\nWe retain your information only for as long as necessary to fulfill the purposes outlined in this Privacy Policy. You may request the deletion of your account and associated data at any time.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Updates to Privacy Policy\n\nWe may update this Privacy Policy to reflect changes in our practices or for other operational, legal, or regulatory reasons. We encourage you to review this policy periodically.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'By using our EV application, you agree to the terms outlined in this Privacy Policy. If you have any questions or concerns about our privacy practices, please contact us at .',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      "rujesh10@gmail.com",
                      style: TextStyle(fontSize: 16.0),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
