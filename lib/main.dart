import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_socketio/dio.dart';
import 'package:flutter_socketio/socket.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Chit-Chat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _editingController = TextEditingController();
  final ScrollController _scrollController = ScrollController(initialScrollOffset: 0);
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();

    socketInit();

    fetchMessages().then((value) {
      for (var i = 0; i < value.length; i++) {
        setState(() {
          messages.add(value[i]);
        });
      }
    });

    socket.on('receive_chat', (data) {
      setState(() {
        messages.insert(messages.length, data);
      });
    });
  }

  void _sendMessage() {
    socket.emit("send_chat", {
      "msg_type": "text",
      "text": _editingController.text,
      "user": {
        "avatar_url":
            "https://turtles-cdn.s3-ap-southeast-1.amazonaws.com/assets/user.svg",
        "code": "be788ef3-f0fb-4949-a7eb-429ebf2377e9",
        "name": "Md Abdul Halim Rafi",
        "u_id": 4690
      }
    });

    _editingController.clear();
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        height: media.height,
        width: media.width,
        color: Colors.black87,
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 10,
              child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
				reverse: true,
                itemCount: messages.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          padding: const EdgeInsets.all(10),
                          constraints: BoxConstraints(
                            minWidth: 40,
                            maxWidth: media.width * 0.7,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(0),
                            ),
                          ),
                          child: Text(
                            messages[index]['text'],
                            softWrap: true,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          child: messages[index]["user"]["avatar_url"]
                                  .contains(".svg")
                              ? SvgPicture.network(
                                  messages[index]["user"]["avatar_url"])
                              : Image.network(
                                  messages[index]["user"]["avatar_url"],
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: const BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: media.width * 0.5,
                    child: TextFormField(
                      autofocus: false,
                      autocorrect: false,
                      validator: (val) => val!.isEmpty ? "" : null,
                      keyboardType: TextInputType.multiline,
                      onFieldSubmitted: (_) => _sendMessage(),
                      controller: _editingController,
                      style: const TextStyle(color: Colors.white),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        focusedBorder: InputBorder.none,
                        hintText: "Type your message here",
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: media.width * 0.15,
                    child: Material(
                      color: Colors.blue,
                      type: MaterialType.circle,
                      child: IconButton(
                        color: Colors.white,
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    print("deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    socket.disconnect();
    print("dispose");
    super.dispose();
  }
}
