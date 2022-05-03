class Command {
  final String name;

  Command(this.name);

  static Command clone(Command command) {
    return Command(command.name);
  }
}
