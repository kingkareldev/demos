import 'package:flutter/material.dart';

import 'Command.dart';

class CommandBlock extends StatelessWidget {
  final Command command;

  const CommandBlock({Key? key, required this.command}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        border: Border.all(color: Colors.blueAccent, width: 4),
      ),
      padding: EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      child: Text(command.name),
    );
  }
}
