import 'package:deeplink/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  runApp(MyApp(
    initialLink: initialLink,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.initialLink}) : super(key: key);
  final PendingDynamicLinkData? initialLink;

  @override
  Widget build(BuildContext context) {
    print('---- init link ---- ');
    print(initialLink?.link.path);
    return MaterialApp(
      title: 'Deep linking',
      routes: {
        '/start': (BuildContext context) =>
            const MyHomePage(title: 'Deep linking'),
        '/profile': (BuildContext context) => const ProfileScreen()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/start',
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> initDynamicLinks() async {
  print('init deep linking');
  FirebaseDynamicLinks.instance.onLink.listen((event) {
    final Uri deepLink = event.link;
    print('deep link$deepLink');
  }).onError((e) {
    print(e);
  });
}
