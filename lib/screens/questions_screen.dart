
import 'package:flutter/material.dart';
import 'add_question_screen.dart';
import '../services/api_service.dart';
import '../styles/app_styles.dart';

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
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final data = await ApiService.fetchQuestions();
    setState(() {
      questions = data;
    });
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
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  questions[index]['title'],
                  style: AppStyles.questionTitleStyle,
                ),
                subtitle: Text(
                  questions[index]['description'],
                  style: AppStyles.questionDescriptionStyle,
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
          fetchQuestions();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}