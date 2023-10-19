import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.blueAccent),
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1 ),
          //   child: 
          // )
        ],
      )
    );
  }
}