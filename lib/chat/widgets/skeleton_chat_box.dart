import 'package:flutter/material.dart';

class SkeletonChatBox extends StatelessWidget {
  const SkeletonChatBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 12,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
