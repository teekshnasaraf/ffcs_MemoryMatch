import 'package:flutter/material.dart';

class WinScreen extends StatelessWidget {
  const WinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)!.settings.arguments as Map;

    int p1 = data["p1"];
    int p2 = data["p2"];

    String result;
    if (p1 > p2) {
      result = "🏆 Player 1 Wins!";
    } else if (p2 > p1) {
      result = "🏆 Player 2 Wins!";
    } else {
      result = "🤝 It's a Draw!";
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("Player 1: $p1"),
            Text("Player 2: $p2"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
              child: const Text("Play Again"),
            )
          ],
        ),
      ),
    );
  }
}
