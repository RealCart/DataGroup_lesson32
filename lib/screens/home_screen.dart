import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _createTask() {
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('task')
        .doc()
        .set({
          'title': _controller.text,
          'isDone': false,
          'createdAt': DateTime.now(),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const .symmetric(horizontal: 20.0, vertical: 5.0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  spacing: 8.0,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (value) {
                          _createTask();
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: _createTask,
                      child: Text('+'),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('task')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                }

                final list = snapshot.data!.docs;

                return SliverPadding(
                  padding: const .symmetric(horizontal: 20.0),
                  sliver: SliverList.separated(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index].data();

                      final id = list[index].id;

                      log('$item', name: 'Data');

                      return Container(
                        decoration: BoxDecoration(color: Colors.white30),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(item['title']),
                                Text(
                                  (item['createdAt'] as Timestamp)
                                      .toDate()
                                      .toString(),
                                ),
                              ],
                            ),
                            Checkbox.adaptive(
                              value: item['isDone'],
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection('tasks')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('task')
                                    .doc(id)
                                    .update({
                                      'isDone': value,
                                    });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10.0,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
