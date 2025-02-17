
import 'package:flutter/material.dart';
import 'answers_screen.dart'; // This one imports your answers screen
import 'add_question_screen.dart';
import '../styles/app_styles.dart';
import '../services/socket_service.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  List<dynamic> questions = [];

  @override
  void initState() {
    super.initState();
      // Add dummy data for initial testing
        setState(() {
          questions = [
            {'id': 1, 'title': 'Dummy Question 1', 'description': 'Dummy Description 1'},
            {'id': 2, 'title': 'Dummy Question 2', 'description': 'Dummy Description 2'},
          ];
        });
    SocketService.socket.on('questions_data', (data) {
      setState(() {
        questions = List<Map<String, dynamic>>.from(data);
      });
    });
    SocketService.socket.on('question_added', (data) {
      setState(() {
        questions.add(data);
      });
    });
    SocketService.socket.emit('init_questions');
  }

  @override
  void dispose() {
    SocketService.socket.off('questions_data');
    SocketService.socket.off('question_added');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Questions List', style: AppStyles.appBarTitleStyle)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnswersScreen(questionId: questions[index]['id']),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questions[index]['title'],
                        style: AppStyles.questionTitleStyle.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        questions[index]['description'],
                        style: AppStyles.questionDescriptionStyle.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddQuestionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}