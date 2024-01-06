import 'package:flutter/material.dart';
import 'dart:async';
//import 'dart:math';

void main() => runApp(MemoryGameApp());

class MemoryGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        
       primaryColor: Color.fromARGB(255, 244, 143, 143)
      ),
      home: MemoryGame(),
    );
  }
}

class MemoryGame extends StatefulWidget {
  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {

  
  late List<int> cardIndices;
  late List<bool> cardFlips;
  late int previousIndex;
  late int totalPairs;
  late int openedPairs;
  late bool lockBoard;
  List<IconData> icons = [
    Icons.star,
    Icons.favorite,
    Icons.music_note,
    Icons.home,
    Icons.book,
    Icons.camera,
    Icons.games,
    Icons.mail,
     Icons.shopping_cart,
  Icons.movie,
  Icons.phone,
  Icons.pets,
  Icons.beach_access,
  Icons.local_pizza,
  Icons.train,
  Icons.flight,
  ];

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame({int pairs = 8}) {
    cardIndices = List.generate(pairs * 2, (index) => index ~/ 2);
    cardIndices.shuffle();
    cardFlips = List.filled(pairs * 2, false);
    previousIndex = -1;
    lockBoard = false;
    totalPairs = pairs;
    openedPairs = 0;
  }

  void _onCardTap(int index) {
    if (lockBoard || cardFlips[index]) {
      return;
    }

    setState(() {
      cardFlips[index] = true;

      if (previousIndex == -1) {
        previousIndex = index;
      } else {
        if (cardIndices[previousIndex] != cardIndices[index]) {
          lockBoard = true;
          Timer(Duration(seconds: 1), () {
            setState(() {
              cardFlips[previousIndex] = false;
              cardFlips[index] = false;
              lockBoard = false;
              previousIndex = -1;
            });
          });
        } else {
          openedPairs++;
          if (openedPairs == totalPairs) {
            // Game won
          }
          previousIndex = -1;
        }
      }
    });
  }

  // void _restartGame() {
  //   initializeGame(pairs: totalPairs);
  // }

  void _restartGame() {
  setState(() {
    initializeGame(pairs: totalPairs);
    openedPairs = 0;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Memory Matching Game'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: totalPairs * 2,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _onCardTap(index);
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cardFlips[index] ? Theme.of(context).primaryColor : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: cardFlips[index]
                          ? Icon(
                              icons[cardIndices[index]],
                              size: 32,
                              color: Colors.black,
                            )
                          : Container(),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            if (openedPairs == totalPairs)
              Text(
                'Congratulations, you opened all pairs!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              onPressed: _restartGame,
             
              child: Text('Restart',style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}
