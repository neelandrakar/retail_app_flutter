// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DiscussionQuestionModel {
  final String id;
  final int question_id;
  final int question_parent_id;
  final String question_parent_name;
  final String question;
  final int is_mandatory;
  final int d_status;
  final int answer_type;
  DiscussionQuestionModel({
    required this.id,
    required this.question_id,
    required this.question_parent_id,
    required this.question_parent_name,
    required this.question,
    required this.is_mandatory,
    required this.d_status,
    required this.answer_type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'question_id': question_id,
      'question_parent_id': question_parent_id,
      'question_parent_name': question_parent_name,
      'question': question,
      'is_mandatory': is_mandatory,
      'd_status': d_status,
      'answer_type': answer_type,
    };
  }

  factory DiscussionQuestionModel.fromMap(Map<String, dynamic> map) {
    return DiscussionQuestionModel(
      id: map['_id'] as String,
      question_id: map['question_id'] as int,
      question_parent_id: map['question_parent_id'] as int,
      question_parent_name: map['question_parent_name'] as String,
      question: map['question'] as String,
      is_mandatory: map['is_mandatory'] as int,
      d_status: map['d_status'] as int,
      answer_type: map['answer_type'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DiscussionQuestionModel.fromJson(String source) =>
      DiscussionQuestionModel.fromMap(json.decode(source));
}
