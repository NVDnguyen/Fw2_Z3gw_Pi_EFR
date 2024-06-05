import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot_app/models/system_log.dart';
import 'package:iot_app/models/users.dart';
import 'package:iot_app/provider/data_user.dart';
import 'package:iot_app/services/realtime_firebase.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Users user;
  TextEditingController _messageController = TextEditingController();

  List<String> lSystem = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      user = await SharedPreferencesProvider.getDataUser();
      Users userNew = await DataFirebase.getUserRealTime(user);

      if (userNew != user) {
        user = userNew;
        SharedPreferencesProvider.setDataUser(user);
      }

      setState(() {
        lSystem = user.getSystemIDs();
      });
    } catch (e) {
      _showErrorDialog(e.toString());
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Stream<List<SystemLog>> listLog = DataFirebase.getStreamLogs(lSystem);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Bot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<SystemLog>>(
              stream: listLog,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No device data'));
                }

                final data = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final log = data[index];
                    final DateTime dateTime = DateTime.parse(log.timestamp);
                    final String formattedDate =
                        DateFormat('dd-MM-yyyy – kk:mm:ss').format(dateTime);
                    return ListTile(
                      title: Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(log.message),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    setState(() {
      _messageController.clear();
    });
    // Send message to chat bot and get response
    // Use GPT API to generate response
    // Display response in chat
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
