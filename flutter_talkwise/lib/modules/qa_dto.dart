class QA {
  final int id;
  final String question;
  final String answer;

  const QA({
    this.id = 0,
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> qaMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}
