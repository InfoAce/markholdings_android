import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.grey[600]),
        child: TextField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            prefixIcon: const Icon(Icons.search),
            fillColor: Colors.white,
            hintStyle: TextStyle(color: Colors.grey[600]),
            hintText: "What would your like to buy?",
          ),
          autofocus: false,
        ),
      ),
    );
  }
}