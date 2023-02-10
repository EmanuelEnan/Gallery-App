import 'package:flutter/material.dart';
import 'package:gallery_app/models/bookmarks.dart';
import 'package:gallery_app/widgets/image_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';

class SavePage extends StatefulWidget {
  const SavePage({Key? key}) : super(key: key);

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  @override
  Widget build(BuildContext context) {
    // String tweet = widget.data.toString();

    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Bookmarks>(boxName).listenable(),
          builder: (context, box, _) {
            if (Hive.box<Bookmarks>(boxName).values.isEmpty) {
              return const Center(
                child: Text('no data'),
              );
            }
            return Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: imageWidget1(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      // width: MediaQuery.of(context).size.width,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: Hive.box<Bookmarks>(boxName).length,
                        itemBuilder: (context, index) {
                          // final transactions = box.getAt(index) as Transaction;
                          int itemCount = Hive.box<Bookmarks>(boxName).length;
                          int reversedIndex = itemCount - 1 - index;
                          final bookmarks = Hive.box<Bookmarks>(boxName)
                              .values
                              .toList()
                              .reversed
                              .toList();

                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * .4,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Center(
                                    child: Image.network(
                                      bookmarks[index].photoUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 28,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () async {
                                          await Hive.box<Bookmarks>(boxName)
                                              .deleteAt(reversedIndex);
                                          // setState(() {});
                                          print('deleted');
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(
                          height: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
