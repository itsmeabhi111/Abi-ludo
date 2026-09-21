import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() => runApp(const AbiLudo());

class AbiLudo extends StatelessWidget {
  const AbiLudo({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abi Ludo',
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0;
  @override
  void initState() {
    super.initState();
    _load();
  }
  _load() async {
    for(int i=0; i<=100; i+=5) {
      await Future.delayed(const Duration(milliseconds: 40));
      setState(() => progress = i/100);
    }
    if(mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GameScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('Abbi', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 30),
        Text('${(progress*100).toInt()}%', style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 10),
        SizedBox(width: 200, child: LinearProgressIndicator(value: progress, color: Colors.deepPurple))
      ])),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioPlayer _audio = AudioPlayer();
  int dice = 1; int currentPlayer = 0; bool isRolling = false;
  final colors = [Colors.red, Colors.blue, Colors.green, Colors.orange];
  final names = ["Red", "Blue", "Green", "Yellow"];
  
  Future<void> playSound(String file) async {
    try { await _audio.play(AssetSource('sounds/$file')); } catch(e){}
  }
  void rollDice() async {
    if(isRolling) return;
    setState(() => isRolling = true);
    playSound('dice_roll.mp3');
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      dice = Random().nextInt(6) + 1;
      isRolling = false;
      if(dice!= 6) currentPlayer = (currentPlayer + 1) % 4;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(title: Text('${names[currentPlayer]} ko palo'), backgroundColor: colors[currentPlayer]),
      body: Column(children: [
        Expanded(child: Center(child: Text("Ludo Board Audaichha", style: TextStyle(color: colors[currentPlayer], fontSize: 20)))),
        GestureDetector(
          onTap: rollDice,
          child: Container(
            width: 100, height: 100, margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: colors[currentPlayer], blurRadius: 20)]),
            child: Center(child: Text('$dice', style: const TextStyle(fontSize: 60, color: Colors.black))),
          ),
        ),
      ]),
    );
  }
}
