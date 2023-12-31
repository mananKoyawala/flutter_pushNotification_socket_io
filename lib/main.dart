import 'package:flutter/material.dart';
import 'package:socket_io_basics/SocketUtils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = TextEditingController();
  WebSocketChannel? channel;
  String status = '';
  SocketUtils socketUtils = SocketUtils();
  List<String> message = [];

  @override
  void initState() {
    super.initState();
    // connectSocketChannel();
  }

  // This is Writtern Script Call

  // This is automatic
  connectSocketChannel() {
    // Both are working well
    channel = IOWebSocketChannel.connect('wss://echo.websocket.events');
    // channel =
    //     WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));
  }

  void sendMessage() {
    channel!.sink.add(controller.text);
  }

  @override
  void dispose() {
    super.dispose();
    channel!.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 45),
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      return;
                    }
                    // sendMessage();
                    socketUtils.sendMessage(
                        controller.text, connectionListner, messageListner);
                  },
                  child: const Text(
                    'Click Here',
                    style: TextStyle(fontSize: 18),
                  )),
              const SizedBox(height: 30),
              Text(
                status,
                style: const TextStyle(fontSize: 18),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: message.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 25),
                          child: Text(message[index]),
                        );
                      }))
              // StreamBuilder(
              //     stream: channel!.stream,
              //     builder: (context, snapshot) {
              //       return snapshot.hasData
              //           ? Text(
              //               snapshot.data,
              //               style: const TextStyle(fontSize: 18),
              //             )
              //           : const Text('');
              //     })
            ],
          ),
        ),
      ),
    );
  }

  void messageListner(String m) {
    setState(() {
      message.add(m);
    });
  }

  void connectionListner(bool connected) {
    setState(() {
      status =
          'Status :${connected ? 'Connected' : 'Failed to connect to server'}';
    });
  }
}
