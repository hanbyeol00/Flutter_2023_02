import 'package:flutter/material.dart';
import 'package:flutter_talkwise/modules/category_dto.dart';
import 'package:flutter_talkwise/persistence/talkwise_db_service.dart';
import 'package:flutter_talkwise/screen/Home.dart';
import 'package:flutter_talkwise/screen/category_view.dart';
import 'package:flutter_talkwise/ui_modles/Home_View_model.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
              builder: (context) => const NavPage(body: Home()));
        } else if (settings.name != null &&
            settings.name!.startsWith('/category/')) {
          final bookmark = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) =>
                NavPage(body: CategoryView(bookmark: bookmark)),
          );
        }
        return null;
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
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: <Widget>[
              const SizedBox(
                width: double.infinity,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('북마크'),
                ),
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
                    onTap: () {
                      viewModel.onSelectedChanged(1);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/category/all",
                        (route) => false,
                      );
                    },
                  ),
                  FutureBuilder(
                    future: TalkWiseDBService().getCategoryList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Category>> snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data!.map((category) {
                            final int index = snapshot.data!.indexOf(category);
                            return ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  category.category,
                                  style: viewModel.selectedIndex == index + 2
                                      ? const TextStyle(
                                          fontWeight: FontWeight.bold)
                                      : null,
                                ),
                              ),
                              selected: viewModel.selectedIndex == index + 2,
                              onTap: () {
                                viewModel.onSelectedChanged(index + 2);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  "/category/${category.category}",
                                  (route) => false,
                                );
                              },
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text("");
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
