import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:taza_khabhar/cateogry.dart';
import 'package:taza_khabhar/model.dart';
import 'package:taza_khabhar/searchPage.dart';
import 'package:taza_khabhar/webView.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  List navItems = [
    "Latest",
    "Politics",
    "Health",
    " Sports",
    "Regular ",
    "Finance",
    "India",
    "Top News"
  ];
  List<newsQueryModel> newsList = <newsQueryModel>[];
  List<newsQueryModel> newsListCarousel = <newsQueryModel>[];
  getNews(String query) async {
    Map element;
    int i = 0;
    print(query);
    Uri url = Uri.parse(
        "https://newsapi.org/v2/everything?q=$query&from=2024-07-01&sortBy=publishedAt&apiKey=5171434b8c9a4c9bbb6490913fbc6c61");
    Response response = await http.get(url);
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      print(data);
      setState(() {
        for (element in data["articles"]) {
          try {
            i++;

            newsQueryModel newsqueryModel = newsQueryModel();
            newsqueryModel = newsQueryModel.fromMap(element);
            newsList.add(newsqueryModel);
            setState(() {
              isLoading = false;
            });

            if (i == 8) {
              break;
            }
            log(newsList.toString());
          } catch (e) {
            print(e);
          }
          ;
        }
      });
    } else {
      print("query Failed");
    }
  }

  getLatestNews() async {
    int i =0;
    Map element;
    Uri url = Uri.parse(
        "https://newsapi.org/v2/everything?q=timesofindia&from=2024-07-01&sortBy=publishedAt&apiKey=5171434b8c9a4c9bbb6490913fbc6c61");
    Response response = await http.get(url);
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      print(data);
      setState(() {
        for (element in data["articles"]) {
          try {
            i++;

            newsQueryModel newsqueryModel = newsQueryModel();
            newsqueryModel = newsQueryModel.fromMap(element);
            newsListCarousel.add(newsqueryModel);
            setState(() {
              isLoading = false;
            });

            if (i == 8) {
              break;
            }
            log(newsList.toString());
          } catch (e) {
            print(e);
          }
          ;
        }
      });
    } else {
      print("query not provided by api ");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLatestNews();
    getNews("aajtak");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Taza Khabhare "),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
              height: 70,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: navItems.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Cateogry(s: navItems[index])));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.blueAccent),
                        child: Text(
                          navItems[index],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 14,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
              child: CarouselSlider(
                options: CarouselOptions(height: 220.0),
                items: newsListCarousel.map((instance) {
                  return Builder(builder: (BuildContext context) {
                    try {
                      return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Card(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    instance.newsImage,
                                    fit: BoxFit.cover,
                                    width: double.maxFinite,
                                    height: 240,
                                  ),
                                ),
                                Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: 80,
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
                                          Text(instance.newsHead,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white)),
                                          Text(
                                              instance.newsDesc.length > 50
                                                  ? "${instance.newsDesc.substring(0, 50)}...."
                                                  : instance.newsDesc,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11))
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ));
                    } catch (e) {
                      print(e);
                      return Container();
                    }
                    ;
                  });
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 19, vertical: 6.8),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "LATEST NEWS",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: newsList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        try{
                        return Container(
                          child: InkWell(
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
                                            fit: BoxFit.cover,
                                            height: 300,
                                            width: double.infinity)),
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          height: 80,
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
                                                  newsList[index]
                                                              .newsDesc
                                                              .length >
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
                              )),
                        );
                        }catch(e){print(e) ;return Container();};
                      }),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 14, 0, 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              "READ MORE",
                              style: TextStyle(fontSize: 20),
                            ))
                      ],
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
}
