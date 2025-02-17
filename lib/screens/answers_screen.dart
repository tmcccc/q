
import 'package:flutter/material.dart';
import '../services/socket_service.dart';
import '../styles/app_styles.dart';

class AnswersScreen extends StatefulWidget {
  final int questionId;

  const AnswersScreen({super.key, required this.questionId});

  @override
  _AnswersScreenState createState() => _AnswersScreenState();
}

class _AnswersScreenState extends State<AnswersScreen> {
  List<dynamic> answers = [];

  @override
  void initState() {
    super.initState();
    SocketService.socket.emit('join_room', {'questionId': widget.questionId});
    SocketService.socket.on('answers_data', (data) {
      setState(() {
        answers = List<Map<String, dynamic>>.from(data);
      });
    });
  }

  @override
  void dispose() {
    SocketService.socket.emit('leave_room', {'questionId': widget.questionId});
    SocketService.socket.off('answers_data');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Answers', style: AppStyles.appBarTitleStyle)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: answers.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  answers[index]['text'],
                  style: AppStyles.questionDescriptionStyle.copyWith(fontSize: 16),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
