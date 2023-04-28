import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/bottom_sheet/gf_bottom_sheet.dart';
import '../../di.dart';
import '../database_helper.dart';
import '../model/word_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final db = di.get<DatabaseHelper>();
  final controller = TextEditingController();
  var words = <WordModel>[];
  var isUz = false;

  @override
  void initState() {
    print("InitState");
    search();
    controller.addListener(() {
      search();
    });
    super.initState();
  }

  void search() {
    EasyDebounce.debounce(
      'my-bouncer',
      const Duration(milliseconds: 300),
      () async {
        if (isUz) {
          words = await db.findByUz(controller.text);
        } else {
          words = await db.findByEn(controller.text);
        }
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    EasyDebounce.cancel('my-bouncer');
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        title: const Text("Dictionary"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          children: [
            // Container(
            //   margin: const EdgeInsets.only(bottom: 8),
            //   child: Row(
            //     children: [
            //       Expanded(
            //           child: Text(
            //         isUz ? "Uz -> En" : "En -> Uz",
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontSize: 24, color: Colors.green.shade900, fontWeight: FontWeight.bold),
            //       )),
            //     ],
            //   ),
            // ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    // onChanged: (value) {
                    //
                    // },
                    scrollPadding: const EdgeInsets.all(0),
                    decoration: const InputDecoration(contentPadding: EdgeInsets.all(0), border: OutlineInputBorder(), focusColor: Color(0xFF1B5E20)),
                  ),
                ),
                // const SizedBox(width: 8),
                // GestureDetector(
                //   onTap: () {
                //     // controller.text = "Hi";
                //     isUz = !isUz;
                //     setState(() {});
                //     search();
                //   },
                //   behavior: HitTestBehavior.opaque,
                //   child: const Icon(
                //     Icons.change_circle_rounded,
                //     size: 40,
                //     color: Color(0xFF1B5E20),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Builder(builder: (context) {
                if (words.isEmpty) {
                  return Image.asset("assets/images/empty.png");
                }
                return ListView.separated(
                  itemCount: words.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 18),
                  itemBuilder: (context, i) {
                    return InkWell(
                        onTap: () {
                          description(context, words[i]);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: const BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            isUz ? words[i].uzbek : words[i].english,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ));
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void description(BuildContext context, WordModel word) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(children: [
            const SizedBox(height: 30),
            Text(
              isUz ? word.uzbek : word.english,
              style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              isUz ? word.english : word.uzbek,
              style: const TextStyle(color: Colors.green, fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              word.transcript,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Text(
              word.countable ?? "",
              style: const TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
            )
          ]);
        });
  }
}
