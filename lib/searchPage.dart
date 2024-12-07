import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import "package:http/http.dart"as http;
import 'package:http/http.dart';
import 'package:taza_khabhar/webView.dart';

import 'model.dart';

class SearchPage extends StatefulWidget {
  String s = "";
  SearchPage({required this.s});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<newsQueryModel> newsList = <newsQueryModel>[];


  getNews(String query) async {
    print(query);
    Uri url = Uri.parse(
        "https://newsapi.org/v2/everything?q=$query&from=2024-07-01&sortBy=publishedAt&apiKey=5171434b8c9a4c9bbb6490913fbc6c61");

    Response response = await http.get(url);
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      print(data);
      data["articles"].forEach((element) {
        newsQueryModel newsqueryModel = newsQueryModel();
        newsqueryModel = newsQueryModel.fromMap(element);
        newsList.add(newsqueryModel);
        log(newsList.toString());
      });
    } else {
      print("query Failed");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews(widget.s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.s,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SearchPage(s: searchController.text)));
                          },
                          child: const Icon(
                            Icons.search,
                            size: 15,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search News",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                  Container(
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: newsList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            webView(newsList[index].newsUrl)));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: Card(
                                    child: Stack(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          newsList[index].newsImage,
                                          fit: BoxFit.fitHeight,
                                          height: 230,
                                          width: double.infinity,
                                        )),
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          height: 60,
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 10, 8, 8),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                Colors.black12.withOpacity(0),
                                                Colors.black,
                                              ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(newsList[index].newsHead,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white)),
                                              Text(
                                                  newsList[index].newsDesc.length >
                                                          50
                                                      ? "${newsList[index].newsDesc.substring(0, 50)}...."
                                                      : newsList[index].newsDesc,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11))
                                            ],
                                          ),
                                        )),
                                  ],
                                )),
                              ));
                        }),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
