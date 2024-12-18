// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.34.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class GameResults {
  final List<QuestionAnswered> userAnswers;
  final List<PlayerResult> playersResults;

  const GameResults({
    required this.userAnswers,
    required this.playersResults,
  });

  @override
  int get hashCode => userAnswers.hashCode ^ playersResults.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameResults &&
          runtimeType == other.runtimeType &&
          userAnswers == other.userAnswers &&
          playersResults == other.playersResults;
}

class PlayerResult {
  final String username;
  final String avatarColor;
  final bool isOnline;
  final int scoreChange;
  final int correctAnswerCount;
  final int wrongAnswerCount;
  final int avgAnswerTime;

  const PlayerResult({
    required this.username,
    required this.avatarColor,
    required this.isOnline,
    required this.scoreChange,
    required this.correctAnswerCount,
    required this.wrongAnswerCount,
    required this.avgAnswerTime,
  });

  @override
  int get hashCode =>
      username.hashCode ^
      avatarColor.hashCode ^
      isOnline.hashCode ^
      scoreChange.hashCode ^
      correctAnswerCount.hashCode ^
      wrongAnswerCount.hashCode ^
      avgAnswerTime.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerResult &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          avatarColor == other.avatarColor &&
          isOnline == other.isOnline &&
          scoreChange == other.scoreChange &&
          correctAnswerCount == other.correctAnswerCount &&
          wrongAnswerCount == other.wrongAnswerCount &&
          avgAnswerTime == other.avgAnswerTime;
}

class QuestionAnswered {
  final String question;
  final List<String> answers;
  final int correctAnswer;
  final int userAnswer;
  final int timeTaken;

  const QuestionAnswered({
    required this.question,
    required this.answers,
    required this.correctAnswer,
    required this.userAnswer,
    required this.timeTaken,
  });

  @override
  int get hashCode =>
      question.hashCode ^
      answers.hashCode ^
      correctAnswer.hashCode ^
      userAnswer.hashCode ^
      timeTaken.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAnswered &&
          runtimeType == other.runtimeType &&
          question == other.question &&
          answers == other.answers &&
          correctAnswer == other.correctAnswer &&
          userAnswer == other.userAnswer &&
          timeTaken == other.timeTaken;
}
