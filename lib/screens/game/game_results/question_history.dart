import '../../../src/rust/api/request/get_question.dart';

class QuestionHistory {
  final Question question;
  final int rightAnswerIndex;
  final int? answerIndex;

  QuestionHistory(this.question, this.rightAnswerIndex, this.answerIndex);
}