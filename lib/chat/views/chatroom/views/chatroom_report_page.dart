import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:likeminds_flutter_sample/chat/widgets/back_button.dart' as bb;

class ChatroomReportPage extends StatefulWidget {
  const ChatroomReportPage({super.key});

  @override
  State<ChatroomReportPage> createState() => _ChatroomReportPageState();
}

class _ChatroomReportPageState extends State<ChatroomReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 72),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const bb.BackButton(),
                Text(
                  "Report Chatroom",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              "Please specify the problem to continue",
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "You would be able to report this message after selecting a problem.",
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 24),
            const ChoiceChip(
              label: Text("Spam"),
              selected: false,
            ),
          ],
        ),
      ),
    );
  }
}
