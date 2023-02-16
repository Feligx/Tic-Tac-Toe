import 'package:flutter/material.dart';

import '../utils/board.dart';

class BoardGrid extends StatefulWidget {
  String? currentTurn;
  final Function onTap;
  final Board board;

  BoardGrid({Key? key, this.currentTurn, required this.board, required this.onTap}) : super(key: key);

  @override
  State<BoardGrid> createState() => _BoardGridState();
}

class _BoardGridState extends State<BoardGrid> {

  @override
  Widget build(BuildContext context) {

    var borderColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black;

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      padding: const EdgeInsets.all(30.0),
      children: widget.board.gridWidgets,
    );
  }
}
