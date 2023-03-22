import 'package:flutter/material.dart';
import 'package:flutter_talkwise/screen/Home.dart';
import 'package:flutter_talkwise/ui_modles/Home_View_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/",
      routes: {
        "/": (context) => const NavPage(body: Home()),
        // "/category": (context) => const NavPage(body: ImagePage()),
      },
    );
  }
}

class NavPage extends StatefulWidget {
  const NavPage({
    super.key,
    required this.body,
  });
  final Widget body;

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Talkwise'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: widget.body,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('북마크'),
            ),
            ListTile(
              title: Text(
                '질문하기',
                style: viewModel.selectedIndex == 0
                    ? const TextStyle(fontWeight: FontWeight.bold)
                    : null,
              ),
              selected: viewModel.selectedIndex == 0,
              onTap: () {
                viewModel.onSelectedChanged(0);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/",
                  (route) => false,
                );
              },
            ),
            ExpansionTile(
              title: Text(
                '카테고리',
                style: viewModel.selectedIndex >= 1
                    ? const TextStyle(fontWeight: FontWeight.bold)
                    : null,
              ),
              children: <Widget>[
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'All',
                      style: viewModel.selectedIndex == 1
                          ? const TextStyle(fontWeight: FontWeight.bold)
                          : null,
                    ),
                  ),
                  selected: viewModel.selectedIndex == 1,
                  onTap: () => viewModel.onSelectedChanged(1),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      '예시북마크 1',
                      style: viewModel.selectedIndex == 2
                          ? const TextStyle(fontWeight: FontWeight.bold)
                          : null,
                    ),
                  ),
                  selected: viewModel.selectedIndex == 2,
                  onTap: () {
                    viewModel.onSelectedChanged(2);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/",
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
