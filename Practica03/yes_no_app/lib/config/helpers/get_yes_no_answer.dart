import 'dart:math';
import 'package:dio/dio.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:yes_no_app/infrastructure/models/yes_no_model.dart';

class GetYesNoAnswer {
  final _dio = Dio();

  // 40% yes, 40% no, 20% maybe
  String _randomAnswer() {
    final n = Random().nextInt(100); // 0 a 99
    if (n < 40) return 'yes';
    if (n < 80) return 'no';
    return 'maybe';
  }

  Future<Message> getAnswer() async {
    final response = await _dio.get(
      'https://yesno.wtf/api',
      queryParameters: {'force': _randomAnswer()},
    );

    final yesNoModel = YesNoModel.fromJsonMap(response.data);
    return yesNoModel.toMessageEntity();
  }
}