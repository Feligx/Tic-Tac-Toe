import 'package:flutter/material.dart';

class Board {
  String turn  = "X";
  late String winner;
  List grid = [];
  List<Widget> gridWidgets = [];
  int length = 9;
  Widget turnIcon = const Icon(Icons.close);
  int turnCount = 0;

  Board(int size, Function onTap, context) {
    length = size;
    winner = '';

    for (int i = 0; i < length / 3; i++) {
      grid.add([]);
      for (int j = 0; j < length / 3; j++) {
        grid[i].add('');
      }
    }

    generateGridTiles(onTap, context);

  }

  void showWinnerDialog(onTap, context, setState) {
    bool shouldReset = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Winner: $winner'),
          content: const Text('Do you want to play again?'),
          actions: [
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                shouldReset = true;
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                shouldReset = false;
              },
            ),
          ],
        );
      },
    ).then((value) => {
      if (shouldReset) {
        setState(() {
          resetGrid(onTap, context);
        })
      }
    });
  }

  void generateGridTiles(onTap, BuildContext context) {

    gridWidgets = [];

    tap(int x, int y) {
      if (winner != '') return;
      updateGrid(x, y, turn, onTap, context);
      onTap(this, (setState) => showWinnerDialog(onTap, context, setState));
      turnCount++;
    }

    for (int i = 0; i < length / 3; i++) {
      for (int j = 0; j < length / 3; j++) {
        BoxDecoration? borders;
        if (j == 1 && i == 1) {
          borders = const BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.black,
                width: 2,
              ),
              left: BorderSide(
                color: Colors.black,
                width: 2,
              ),
              top: BorderSide(
                color: Colors.black,
                width: 2,
              ),
              bottom: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          );
        } else if (j == 1) {
          borders = const BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.black,
                width: 2,
              ),
              left: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          );
        } else if (i == 1) {
          borders = const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: 2,
              ),
              bottom: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          );
        } else {
          borders = null;
        }

        gridWidgets.add(
            InkWell(
              onTap: () => tap(i, j),
              child: GridTile(
                child: Container(
                  decoration: borders,
                  child: Center(child: getTile(grid[i][j])),
                ),
              )
            )
        );
      }
    }
  }

  void checkWinner(int x, int y) {
    var currTurn = grid[x][y];
    var count = 0;

    // Check row
    for (int i = 0; i < length / 3; i++) {
      if (grid[x][i] == currTurn) {
        count++;
      }
    }
    if (count == 3) {
      winner = currTurn;
      return;
    }

    // Check column
    count = 0;
    for (int i = 0; i < length / 3; i++) {
      if (grid[i][y] == currTurn) {
        count++;
      }
    }
    if (count == 3) {
      winner = currTurn;
      return;
    }

    // Check diagonal
    count = 0;
    for (int i = 0; i < length / 3; i++) {
      if (grid[i][i] == currTurn) {
        count++;
      }
    }
    if (count == 3) {
      winner = currTurn;
      return;
    }

    // Check anti-diagonal
    count = 0;
    for (int i = 0; i < length / 3; i++) {
      if (grid[i][(length / 3 - i - 1).floor()] == currTurn) {
        count++;
      }
    }
    if (count == 3) {
      winner = currTurn;
      return;
    }

    winner = '';
  }

  Widget getTile(value) {
    var iconSize = 100.0;

    if (value == "X") {
      return Icon(Icons.close, color: Colors.red, size: iconSize,);
    } else if (value == "O") {
      return Icon(Icons.circle_outlined, color: Colors.blue, size: iconSize,);
    } else {
      return const Text('');
    }
  }

  void updateGrid(int x, int y, currTurn, onTap, context) {

    if (grid[x][y] == '') {
      grid[x][y] = currTurn;
      generateGridTiles(onTap, context);
      if (currTurn == "X") {
        turn = "O";
        turnIcon = const Icon(Icons.circle, color: Colors.blue);
      } else {
        turn = "X";
        turnIcon = const Icon(Icons.close, color: Colors.red);
      }
    }

    if (winner == '') {
      checkWinner(x, y);
    }

  }

  void resetGrid(Function onTap, context) {
    for (int i = 0; i < length / 3; i++) {
      for (int j = 0; j < length / 3; j++) {
        grid[i][j] = '';
      }
    }
    turn = "X";
    turnIcon = const Icon(Icons.close);
    winner = '';
    generateGridTiles(onTap, context);
  }
}