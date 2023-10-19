import 'dart:async';

import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  CustomSearchBar(
    {super.key, 
    required this.placeholder,
    required this.callback
  });

  final String placeholder;
  final Function callback;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.grey[600]),
          child: TextField(
            onChanged: (dynamic text) {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 1000), () {
                widget.callback(text);
              });
            },            
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              prefixIcon: const Icon(Icons.search),
              fillColor: Colors.white,
              hintStyle: TextStyle(color: Colors.grey[600]),
              hintText: widget.placeholder,
            ),
            autofocus: false,
          )
        ),
      ),
    );
  }
}