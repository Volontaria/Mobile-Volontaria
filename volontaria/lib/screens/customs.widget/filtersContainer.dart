import 'package:flutter/material.dart';

class FiltersContainer extends StatelessWidget {
  final List<Widget> children;

  FiltersContainer(this.children);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 70.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }
}
