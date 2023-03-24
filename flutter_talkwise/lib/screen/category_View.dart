import 'package:flutter/material.dart';
import 'package:flutter_talkwise/modules/qa_dto.dart';
import 'package:flutter_talkwise/persistence/talkwise_db_service.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key, required this.bookmark});

  final String bookmark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CategoryPage(bookmark: bookmark),
    );
  }
}

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key, required this.bookmark}) : super(key: key);

  final String bookmark;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.bookmark == "all"
          ? TalkWiseDBService().qaSelectAll()
          : TalkWiseDBService().selectCategory(widget.bookmark),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (widget.bookmark == "all") {
            final data = snapshot.data as List<QA>;
            print(widget.bookmark);
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(data[index].question),
                      subtitle: Text(data[index].answer),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                );
              },
            );
          } else {
            final data = snapshot.data as List<dynamic>;
            // ...
            return const Text("data");
          }
        } else {
          return const Text("No data");
        }
      },
    );
  }
}
