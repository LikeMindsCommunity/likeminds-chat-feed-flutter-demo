import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:google_fonts/google_fonts.dart';
import "../../../widgets/back_button.dart" as bb;

class ChatroomPollsPage extends StatefulWidget {
  const ChatroomPollsPage({super.key});

  @override
  State<ChatroomPollsPage> createState() => _ChatroomPollsPageState();
}

class _ChatroomPollsPageState extends State<ChatroomPollsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 72),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const bb.BackButton(),
                Text(
                  "Create Poll",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: polls().length,
              itemBuilder: (BuildContext context, int index) {
                final Map<String, dynamic> poll = polls()[index];

                final int days = DateTime(
                  poll['end_date'].year,
                  poll['end_date'].month,
                  poll['end_date'].day,
                )
                    .difference(DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                    ))
                    .inDays;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: FlutterPolls(
                      pollId: poll['id'].toString(),
                      // hasVoted: hasVoted.value,
                      // userVotedOptionId: userVotedOptionId.value,
                      onVoted:
                          (PollOption pollOption, int newTotalVotes) async {
                        await Future.delayed(const Duration(seconds: 1));
                        pollOption.votes++;

                        /// If HTTP status is success, return true else false
                        return true;
                      },
                      pollEnded: false,
                      pollTitle: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          poll['question'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      pollOptions: List<PollOption>.from(
                        poll['options'].map(
                          (option) {
                            var a = PollOption(
                              id: option['id'],
                              title: Text(
                                option['title'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              votes: option['votes'],
                            );
                            return a;
                          },
                        ),
                      ),
                      votedPercentageTextStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      metaWidget: Row(
                        children: [
                          const SizedBox(width: 6),
                          const Text(
                            '•',
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            days < 0 ? "ended" : "ends $days days",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

List polls() => [
      {
        'id': 1,
        'question':
            'Is Flutter the best framework for building cross-platform applications?',
        'end_date': DateTime(2023, 12, 31),
        'options': [
          {
            'id': 1,
            'title': 'Absolutely',
            'votes': 40,
          },
          {
            'id': 2,
            'title': 'Maybe',
            'votes': 20,
          },
          {
            'id': 3,
            'title': 'Meh!',
            'votes': 10,
          },
        ],
      },
      {
        'id': 2,
        'question': 'Do you think Oranguntans have the ability speak?',
        'end_date': DateTime(2022, 12, 31),
        'options': [
          {
            'id': 1,
            'title': 'Yes, they definitely do',
            'votes': 40,
          },
          {
            'id': 2,
            'title': 'No, they do not',
            'votes': 0,
          },
          {
            'id': 3,
            'title': 'I do not know',
            'votes': 10,
          },
          {
            'id': 4,
            'title': 'Why should I care?',
            'votes': 30,
          }
        ],
      },
      {
        'id': 3,
        'question':
            'How do you know that your experience of consciousness is the same as other people’s experience of consciousness?',
        'end_date': DateTime(2022, 12, 31),
        'options': [
          {
            'id': 2,
            'title': 'It is certain that it is the same',
            'votes': 0,
          },
          {
            'id': 3,
            'title': 'How am I supposed to know?',
            'votes': 0,
          },
        ],
      },
    ];
