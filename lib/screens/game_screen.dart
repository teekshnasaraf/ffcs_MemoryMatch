import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> emojis = [
    "🐶","🐱","🦊","🐻",
    "🐼","🦁","🐸","🐵",
    "🐷","🐔","🐙","🦄"
  ]; // 12 emojis

  late List<String> cards;
  late List<bool> flipped;
  late List<int?> matchedBy; // null = not matched, 1 = P1, 2 = P2

  int? firstIndex;
  int? secondIndex;
  bool isChecking = false;

  int currentPlayer = 1;
  int player1Score = 0;
  int player2Score = 0;

  @override
  void initState() {
    super.initState();
    setupGame();
  }

  void setupGame() {
    cards = [...emojis, ...emojis];
    cards.shuffle(Random());

    flipped = List.generate(24, (index) => false);
    matchedBy = List.generate(24, (index) => null);
  }

  void onCardTap(int index) {
    if (isChecking || flipped[index] || matchedBy[index] != null) return;

    setState(() {
      flipped[index] = true;
    });

    if (firstIndex == null) {
      firstIndex = index;
    } else {
      secondIndex = index;
      checkMatch();
    }
  }

  void checkMatch() {
    isChecking = true;

    if (cards[firstIndex!] == cards[secondIndex!]) {
      setState(() {
        matchedBy[firstIndex!] = currentPlayer;
        matchedBy[secondIndex!] = currentPlayer;

        if (currentPlayer == 1) {
          player1Score++;
        } else {
          player2Score++;
        }
      });

      resetTurn();

      if (matchedBy.every((m) => m != null)) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacementNamed(
            context,
            '/win',
            arguments: {
              "p1": player1Score,
              "p2": player2Score,
            },
          );
        });
      }

    } else {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          flipped[firstIndex!] = false;
          flipped[secondIndex!] = false;

          // Switch turn
          currentPlayer = currentPlayer == 1 ? 2 : 1;
        });

        resetTurn();
      });
    }
  }

  void resetTurn() {
    firstIndex = null;
    secondIndex = null;
    isChecking = false;
  }

  Color getCardColor(int index) {
    if (matchedBy[index] == 1) return Colors.blue;
    if (matchedBy[index] == 2) return Colors.red;

    if (flipped[index]) return Colors.white;

    return Colors.deepPurple;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Player $currentPlayer's Turn"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            "Player 1: $player1Score   |   Player 2: $player2Score",
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 24,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onCardTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: getCardColor(index),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: flipped[index] ||
                              matchedBy[index] != null
                          ? Text(
                              cards[index],
                              style: const TextStyle(fontSize: 30),
                            )
                          : const SizedBox(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
