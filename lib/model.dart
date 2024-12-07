class newsQueryModel{


  String newsHead = "";
  String newsDesc = "";
  String newsImage = "";
  String newsUrl = "";


   newsQueryModel();
  newsQueryModel.name({required this.newsImage, required this.newsDesc, required this.newsHead,required this.newsUrl});

  factory newsQueryModel.fromMap(Map news)
  {
    return newsQueryModel.name(
      newsImage : news["urlToImage"],
      newsDesc : news["description"],
      newsHead : news["title"],
      newsUrl : news["url"],
    );
  }


}